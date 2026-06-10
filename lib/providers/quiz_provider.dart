import 'dart:async';
import 'package:flutter/material.dart';
import '../data/models/question_model.dart';
import '../data/repositories/quiz_repository.dart';
import '../data/services/storage_service.dart';
import '../data/services/audio_service.dart';

class QuizProvider with ChangeNotifier {
  final QuizRepository _repository = QuizRepository();
  final StorageService _storageService = StorageService();
  final AudioService _audioService = AudioService();

  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _lives = 3;
  int _streak = 0;
  bool _isGameOver = false;
  int? _selectedAnswerIndex;
  bool _isAnswering = false;
  bool _isLoading = true;
  String? _currentCategory;
  int? _currentLevel;

  // Level Lock/Unlock
  int _unlockedLevel = 1;

  // Active Timer
  Timer? _questionTimer;
  int _secondsRemaining = 15;
  static const int _maxSeconds = 15;

  // Lifelines
  bool _isFiftyFiftyUsed = false;
  bool _isExtraTimeUsed = false;
  bool _isSkipUsed = false;
  List<int> _removedOptionIndices = [];

  QuizProvider() {
    _init();
  }

  Future<void> _init() async {
    await _repository.initialize();
    _isLoading = false;
    notifyListeners();
  }

  // Getters
  bool get isLoading => _isLoading;
  List<Question> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  int get lives => _lives;
  int get streak => _streak;
  bool get isGameOver => _isGameOver;
  int? get selectedAnswerIndex => _selectedAnswerIndex;
  bool get isAnswering => _isAnswering;
  Question get currentQuestion => _questions[_currentQuestionIndex];
  double get progress => (_currentQuestionIndex + 1) / _questions.length;
  String? get currentCategory => _currentCategory;
  int? get currentLevel => _currentLevel;
  int get unlockedLevel => _unlockedLevel;

  // Timer getters
  int get secondsRemaining => _secondsRemaining;
  double get timerProgress => _secondsRemaining / _maxSeconds;

  // Lifeline getters
  bool get isFiftyFiftyUsed => _isFiftyFiftyUsed;
  bool get isExtraTimeUsed => _isExtraTimeUsed;
  bool get isSkipUsed => _isSkipUsed;
  List<int> get removedOptionIndices => _removedOptionIndices;

  bool get hasNextLevel {
    if (_currentCategory == null || _currentLevel == null) return false;
    final totalLevels = _repository.getLevelsCountForCategory(_currentCategory!);
    return _currentLevel! < totalLevels;
  }

  Future<void> loadUnlockedLevelForCategory(String category) async {
    _unlockedLevel = await _storageService.getUnlockedLevel(category);
    notifyListeners();
  }

  void startQuiz(String category, int level) {
    _currentCategory = category;
    _currentLevel = level;
    _questions = _repository.getQuestionsByCategoryAndLevel(category, level);
    _currentQuestionIndex = 0;
    _score = 0;
    _lives = 3;
    _streak = 0;
    _isGameOver = false;
    _selectedAnswerIndex = null;
    _isAnswering = false;

    // Reset lifelines
    _isFiftyFiftyUsed = false;
    _isExtraTimeUsed = false;
    _isSkipUsed = false;
    _removedOptionIndices = [];

    _audioService.playBackgroundMusic();
    _startTimer();
    notifyListeners();
  }

  // Timer Management
  void _startTimer() {
    _cancelTimer();
    _secondsRemaining = _maxSeconds;
    _questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
        notifyListeners();
      } else {
        _handleTimeout();
      }
    });
  }

  void _cancelTimer() {
    _questionTimer?.cancel();
    _questionTimer = null;
  }

  void _handleTimeout() {
    _cancelTimer();
    if (_isAnswering || _isGameOver) return;
    _isAnswering = true;
    _selectedAnswerIndex = null; // Mark as timeout
    _lives--;
    _streak = 0;
    _audioService.playWrongSound();
    _audioService.vibrate();
    notifyListeners();
  }

  // Lifelines implementation
  void useFiftyFifty() {
    if (_isFiftyFiftyUsed || _isAnswering || _isGameOver) return;
    _isFiftyFiftyUsed = true;
    
    final correctIndex = currentQuestion.correctAnswerIndex;
    final wrongIndices = <int>[];
    for (int i = 0; i < currentQuestion.options.length; i++) {
      if (i != correctIndex) {
        wrongIndices.add(i);
      }
    }
    
    // Randomly select 2 wrong options to hide
    wrongIndices.shuffle();
    _removedOptionIndices = wrongIndices.take(2).toList();
    notifyListeners();
  }

  void useExtraTime() {
    if (_isExtraTimeUsed || _isAnswering || _isGameOver) return;
    _isExtraTimeUsed = true;
    _secondsRemaining += 10;
    if (_secondsRemaining > _maxSeconds) {
      _secondsRemaining = _maxSeconds; // Cap at max seconds
    }
    notifyListeners();
  }

  void useSkipQuestion() {
    if (_isSkipUsed || _isAnswering || _isGameOver) return;
    _isSkipUsed = true;
    _cancelTimer();
    _isAnswering = true;
    // Reveal correct answer without penalty
    _selectedAnswerIndex = currentQuestion.correctAnswerIndex;
    notifyListeners();
  }

  Future<void> answerQuestion(int index) async {
    if (_isAnswering || _isGameOver) return;
    _cancelTimer();
    _isAnswering = true;
    _selectedAnswerIndex = index;

    bool isCorrect = index == currentQuestion.correctAnswerIndex;

    if (isCorrect) {
      _score += 10;
      _streak++;
      if (_streak >= 3) {
        _score += 5; // Streak bonus
      }
      _audioService.playCorrectSound();
    } else {
      _lives--;
      _streak = 0;
      _audioService.playWrongSound();
      _audioService.vibrate();
    }

    notifyListeners();
  }

  void nextQuestionManual() {
    if (_lives <= 0) {
      _endGame();
    } else {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _selectedAnswerIndex = null;
        _isAnswering = false;
        _removedOptionIndices = [];
        _startTimer();
      } else {
        _endGame();
      }
    }
    notifyListeners();
  }

  void _endGame() {
    _isGameOver = true;
    _cancelTimer();
    _audioService.stopBackgroundMusic();
    _storageService.saveHighScore(_score);
    
    // Unlock next level if won
    if (_lives > 0 && _currentCategory != null && _currentLevel != null) {
      _storageService.saveUnlockedLevel(_currentCategory!, _currentLevel! + 1);
    }
    
    notifyListeners();
  }

  void stopQuiz() {
    _cancelTimer();
    _audioService.stopBackgroundMusic();
  }

  void startNextLevel() {
    if (hasNextLevel) {
      startQuiz(_currentCategory!, _currentLevel! + 1);
    }
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }
}
