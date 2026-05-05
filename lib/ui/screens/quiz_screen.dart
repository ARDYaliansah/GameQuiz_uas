import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/quiz_provider.dart';
import 'result_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, provider, child) {
        if (provider.isGameOver) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ResultScreen()),
            );
          });
        }

        final question = provider.currentQuestion;

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0A0E21), Color(0xFF1D2136)],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Top Bar (Lives & Score)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: List.generate(
                            3,
                            (index) => Icon(
                              index < provider.lives ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                              color: index < provider.lives ? Colors.redAccent : Colors.white24,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'SCORE: ${provider.score}',
                                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFFFFD700)),
                              ),
                              if (provider.streak >= 3)
                                Text('STREAK x${provider.streak}', style: const TextStyle(color: Colors.orangeAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Timer
                    Stack(
                      children: [
                        Container(
                          height: 12,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: provider.progress,
                          child: Container(
                            height: 12,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: provider.timerSeconds < 5 
                                  ? [Colors.red, Colors.orange] 
                                  : [const Color(0xFFFFD700), Colors.amber],
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: (provider.timerSeconds < 5 ? Colors.red : const Color(0xFFFFD700)).withValues(alpha: 0.3),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${provider.timerSeconds}s', 
                      style: TextStyle(
                        fontWeight: FontWeight.w900, 
                        color: provider.timerSeconds < 5 ? Colors.redAccent : Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Question Card with Animation
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: _buildQuestionCard(context, provider, question),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuestionCard(BuildContext context, QuizProvider provider, dynamic question) {
    return SingleChildScrollView(
      child: Column(
        key: ValueKey(provider.currentQuestionIndex),
        children: [
          if (question.imageUrl != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: question.imageUrl!.startsWith('http')
                      ? Image.network(
                          question.imageUrl!,
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _buildImageError(),
                        )
                      : Image.asset(
                          question.imageUrl!,
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _buildImageError(),
                        ),
                ),
              ),
            ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Text(
              question.text,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, height: 1.4),
            ),
          ),
          const SizedBox(height: 40),
          // Options
          ...List.generate(
            question.options.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: _OptionButton(
                index: index,
                text: question.options[index],
                isSelected: provider.selectedAnswerIndex == index,
                isCorrect: index == question.correctAnswerIndex,
                showResult: provider.isAnswering,
                onTap: () => provider.answerQuestion(index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageError() {
    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.grey.withValues(alpha: 0.2),
      child: const Icon(Icons.image_not_supported, size: 50, color: Colors.white54),
    );
  }
}

class _OptionButton extends StatelessWidget {
  final int index;
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool showResult;
  final VoidCallback onTap;

  const _OptionButton({
    required this.index,
    required this.text,
    required this.isSelected,
    required this.isCorrect,
    required this.showResult,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color cardColor = Colors.white10;
    if (showResult) {
      if (isCorrect) {
        cardColor = Colors.green.withValues(alpha: 0.6);
      } else if (isSelected && !isCorrect) {
        cardColor = Colors.red.withValues(alpha: 0.6);
      }
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? Colors.white70 : Colors.white24,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: Colors.white24,
              child: Text(
                String.fromCharCode(65 + index),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            if (showResult && isCorrect) const Icon(Icons.check_circle, color: Colors.white),
            if (showResult && isSelected && !isCorrect) const Icon(Icons.cancel, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
