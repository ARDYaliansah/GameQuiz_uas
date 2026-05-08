import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/question_model.dart';

class QuizRepository {
  static final QuizRepository _instance = QuizRepository._internal();
  factory QuizRepository() => _instance;
  QuizRepository._internal();

  List<Question> _allQuestions = [];

  Future<void> initialize() async {
    if (_allQuestions.isNotEmpty) return;
    try {
      final String response = await rootBundle.loadString('assets/data/questions.json');
      final data = await json.decode(response) as List;
      _allQuestions = data.map((q) => Question.fromMap(q)).toList();
    } catch (e) {
      // Fallback for debugging if needed
      print('Error loading questions: $e');
    }
  }

  List<Question> getQuestionsByCategoryAndLevel(String category, int level) {
    final questions = _allQuestions
        .where((q) => q.category == category && q.level == level)
        .toList();
    questions.shuffle();
    return questions;
  }

  int getLevelsCountForCategory(String category) {
    final levels = _allQuestions
        .where((q) => q.category == category)
        .map((q) => q.level)
        .toSet();
    return levels.isEmpty ? 0 : levels.length;
  }

  List<String> getCategories() {
    return ['Teknologi', 'Sejarah', 'Film', 'Sains', 'Tebak Gambar'];
  }
}
