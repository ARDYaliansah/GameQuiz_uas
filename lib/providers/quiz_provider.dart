import 'dart:async';
import 'package:flutter/material.dart';
import '../data/models/question_model.dart';
import '../data/repositories/quiz_repository.dart';
import '../data/services/storage_service.dart';

class QuizProvider with ChangeNotifier {
  final QuizRepository _repository = QuizRepository();
  final StorageService _storageService = StorageService();
  final AudioPlayer _audioPlayer = AudioPlayer();

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

  // Getters
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

  void startQuiz(String category) {
    _questions = _repository.getQuestionsByCategory(category);
    _questions.shuffle();
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
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
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
    _playSound('wrong.wav');
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
      _playSound('correct.wav');
    } else {
      _lives--;
      _streak = 0;
      _playSound('wrong.wav');
    }

    notifyListeners();

    await Future.delayed(Duration(seconds: 2));

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

  void _playSound(String fileName) async {
    try {
      // Assuming assets/sounds/correct.mp3 and assets/sounds/wrong.mp3 exist
      await _audioPlayer.play(AssetSource('sounds/$fileName'));
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}
