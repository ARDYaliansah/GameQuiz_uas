import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/quiz_provider.dart';
import '../../data/repositories/quiz_repository.dart';
import '../../data/models/question_model.dart';
import 'quiz_screen.dart';

class StudyScreen extends StatefulWidget {
  final String category;
  final int level;
  final Color categoryColor;

  const StudyScreen({
    super.key,
    required this.category,
    required this.level,
    required this.categoryColor,
  });

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  late final PageController _pageController;
  late final List<Question> _questions;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _questions = QuizRepository().getQuestionsByCategoryAndLevelForStudy(
      widget.category,
      widget.level,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _getCleanExplanation(Question question) {
    final correctText = question.options[question.correctAnswerIndex];
    if (question.explanation.isEmpty ||
        question.explanation.contains('Pertanyaan level') ||
        question.explanation.contains('kategori')) {
      return 'Jawaban yang benar untuk pertanyaan ini adalah "$correctText". Pelajari pertanyaan ini agar Anda bisa menjawab dengan tepat saat kuis dimulai!';
    }
    return question.explanation;
  }

  void _startQuiz() {
    context.read<QuizProvider>().startQuiz(widget.category, widget.level);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const QuizScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text(
            'Tidak ada materi belajar untuk level ini.',
            style: GoogleFonts.outfit(color: Colors.white, fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Ruang Belajar',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A0E21), Color(0xFF1D2136)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header Info
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: widget.categoryColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: widget.categoryColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _getIcon(widget.category),
                            size: 16,
                            color: widget.categoryColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            widget.category,
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: widget.categoryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Level ${widget.level}',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              // Progress Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: (_currentPage + 1) / _questions.length,
                    backgroundColor: Colors.white.withOpacity(0.05),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      widget.categoryColor,
                    ),
                    minHeight: 6,
                  ),
                ),
              ),

              // Page Indicator Text
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Materi ${_currentPage + 1} dari ${_questions.length}',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Colors.white54,
                    ),
                  ),
                ),
              ),

              // Swipeable Card
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _questions.length,
                  itemBuilder: (context, index) {
                    final question = _questions[index];
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Card Background
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Question Image (if any)
                                if (question.imageUrl != null) ...[
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child:
                                          question.imageUrl!.startsWith('http')
                                          ? Image.network(
                                              question.imageUrl!,
                                              height: 180,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              loadingBuilder:
                                                  (
                                                    context,
                                                    child,
                                                    loadingProgress,
                                                  ) {
                                                    if (loadingProgress == null)
                                                      return child;
                                                    return Container(
                                                      height: 180,
                                                      color: Colors.white
                                                          .withOpacity(0.05),
                                                      child: const Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                              color: Color(
                                                                0xFFFFD700,
                                                              ),
                                                            ),
                                                      ),
                                                    );
                                                  },
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => _buildImageError(),
                                            )
                                          : Image.asset(
                                              question.imageUrl!,
                                              height: 180,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => _buildImageError(),
                                            ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],

                                // Question Text
                                Text(
                                  question.text,
                                  style: GoogleFonts.outfit(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Options List
                                ...List.generate(question.options.length, (
                                  optIndex,
                                ) {
                                  final isCorrect =
                                      optIndex == question.correctAnswerIndex;
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                        horizontal: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isCorrect
                                            ? const Color(
                                                0xFF00FF87,
                                              ).withOpacity(0.15)
                                            : Colors.white.withOpacity(0.02),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isCorrect
                                              ? const Color(
                                                  0xFF00FF87,
                                                ).withOpacity(0.4)
                                              : Colors.white.withOpacity(0.05),
                                          width: isCorrect ? 1.5 : 1,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 12,
                                            backgroundColor: isCorrect
                                                ? const Color(0xFF00FF87)
                                                : Colors.white24,
                                            child: Text(
                                              String.fromCharCode(
                                                65 + optIndex,
                                              ),
                                              style: GoogleFonts.outfit(
                                                color: isCorrect
                                                    ? Colors.black
                                                    : Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              question.options[optIndex],
                                              style: GoogleFonts.outfit(
                                                color: isCorrect
                                                    ? Colors.white
                                                    : Colors.white70,
                                                fontWeight: isCorrect
                                                    ? FontWeight.w600
                                                    : FontWeight.w400,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          if (isCorrect)
                                            const Icon(
                                              Icons.check_circle_rounded,
                                              color: Color(0xFF00FF87),
                                              size: 18,
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Explanation Card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  widget.categoryColor.withOpacity(0.12),
                                  widget.categoryColor.withOpacity(0.03),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: widget.categoryColor.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.lightbulb_outline_rounded,
                                      color: widget.categoryColor,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Penjelasan',
                                      style: GoogleFonts.outfit(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: widget.categoryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  _getCleanExplanation(question),
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.85),
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 80,
                          ), // extra padding for bottom button
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Bottom Navigation & CTA Bar
              Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      const Color(0xFF0A0E21).withOpacity(0.9),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        // Previous Button
                        if (_currentPage > 0)
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: OutlinedButton(
                                onPressed: () {
                                  _pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: widget.categoryColor.withOpacity(
                                      0.4,
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  foregroundColor: Colors.white,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Sebelumnya',
                                      style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                        if (_currentPage > 0 &&
                            _currentPage < _questions.length - 1)
                          const SizedBox(width: 15),

                        // Next Button / Start Quiz
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_currentPage < _questions.length - 1) {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                } else {
                                  _startQuiz();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    _currentPage == _questions.length - 1
                                    ? const Color(0xFFFFD700)
                                    : widget.categoryColor,
                                foregroundColor:
                                    _currentPage == _questions.length - 1
                                    ? Colors.black87
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 3,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _currentPage == _questions.length - 1
                                        ? 'LANJUT KE KUIS!'
                                        : 'Selanjutnya',
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                      letterSpacing:
                                          _currentPage == _questions.length - 1
                                          ? 1.0
                                          : 0.0,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(
                                    _currentPage == _questions.length - 1
                                        ? Icons.sports_esports_rounded
                                        : Icons.arrow_forward_ios_rounded,
                                    size: 14,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Quick Start Quiz link
                    if (_currentPage < _questions.length - 1)
                      TextButton(
                        onPressed: _startQuiz,
                        child: Text(
                          'Lewati & Lanjut ke Kuis',
                          style: GoogleFonts.outfit(
                            color: Colors.white54,
                            decoration: TextDecoration.underline,
                            fontSize: 13,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageError() {
    return Container(
      height: 180,
      width: double.infinity,
      color: Colors.grey.withOpacity(0.2),
      child: const Icon(
        Icons.image_not_supported,
        size: 50,
        color: Colors.white54,
      ),
    );
  }

  IconData _getIcon(String category) {
    switch (category) {
      case 'Teknologi':
        return Icons.settings_input_component_rounded;
      case 'Sejarah':
        return Icons.account_balance_rounded;
      case 'Film':
        return Icons.theaters_rounded;
      case 'Sains':
        return Icons.biotech_rounded;
      case 'Tebak Gambar':
        return Icons.auto_fix_high_rounded;
      default:
        return Icons.auto_awesome_mosaic_rounded;
    }
  }
}
