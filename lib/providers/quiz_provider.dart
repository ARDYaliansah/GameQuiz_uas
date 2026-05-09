import 'dart:async';
import 'package:flutter/material.dart';
import '../data/models/question_model.dart';
import '../data/repositories/quiz_repository.dart';
import '../data/services/storage_service.dart';

class QuizProvider with ChangeNotifier {
  final QuizRepository _repository = QuizRepository();
  final StorageService _storageService = StorageService();

  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _lives = 3;
  int _streak = 0;
  int _timerSeconds = 15;
  Timer? _timer;
  bool _isGameOver = false;
  int? _selectedAnswerIndex;
  bool _isAnswering = false;
  bool _isLoading = true;
  String? _currentCategory;
  int? _currentLevel;

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
  int get timerSeconds => _timerSeconds;
  bool get isGameOver => _isGameOver;
  int? get selectedAnswerIndex => _selectedAnswerIndex;
  bool get isAnswering => _isAnswering;
  Question get currentQuestion => _questions[_currentQuestionIndex];
  double get progress => _timerSeconds / 15;
  String? get currentCategory => _currentCategory;
  int? get currentLevel => _currentLevel;

  bool get hasNextLevel {
    if (_currentCategory == null || _currentLevel == null) return false;
    final totalLevels = _repository.getLevelsCountForCategory(_currentCategory!);
    return _currentLevel! < totalLevels;
  }

  void startQuiz(String category, int level) {
    _currentCategory = category;
    _currentLevel = level;
    _questions = _repository.getQuestionsByCategoryAndLevel(category, level);
    // Note: getQuestionsByCategoryAndLevel already shuffles the questions
    _currentQuestionIndex = 0;
    _score = 0;
    _lives = 3;
    _streak = 0;
    _isGameOver = false;
    _selectedAnswerIndex = null;
    _isAnswering = false;
    _startTimer();
    notifyListeners();
  }

  void _startTimer() {
    _timerSeconds = 15;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        _timerSeconds--;
        notifyListeners();
      } else {
        _handleTimeOut();
      }
    });
  }

  void _handleTimeOut() {
    _timer?.cancel();
    _lives--;
    _streak = 0;
    if (_lives <= 0) {
      _endGame();
    } else {
      _nextQuestion();
    }
    notifyListeners();
  }

  Future<void> answerQuestion(int index) async {
    if (_isAnswering || _isGameOver) return;
    _isAnswering = true;
    _selectedAnswerIndex = index;
    _timer?.cancel();

    bool isCorrect = index == currentQuestion.correctAnswerIndex;

    if (isCorrect) {
      _score += 10;
      _streak++;
      if (_streak >= 3) {
        _score += 5; // Streak bonus
      }
    } else {
      _lives--;
      _streak = 0;
    }

    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    if (_lives <= 0) {
      _endGame();
    } else {
      _nextQuestion();
    }
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      _selectedAnswerIndex = null;
      _isAnswering = false;
      _startTimer();
    } else {
      _endGame();
    }
    notifyListeners();
  }

  void _endGame() {
    _isGameOver = true;
    _timer?.cancel();
    _storageService.saveHighScore(_score);
    notifyListeners();
  }

  void startNextLevel() {
    if (hasNextLevel) {
      startQuiz(_currentCategory!, _currentLevel! + 1);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
