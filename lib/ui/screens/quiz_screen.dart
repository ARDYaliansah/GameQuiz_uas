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
                        IconButton(
                          onPressed: () =>
                              _showQuitConfirmation(context, provider),
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.white70,
                          ),
                          tooltip: 'Keluar Kuis',
                        ),
                        Row(
                          children: List.generate(
                            3,
                            (index) => Icon(
                              index < provider.lives
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_outline_rounded,
                              color: index < provider.lives
                                  ? Colors.redAccent
                                  : Colors.white24,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'SCORE: ${provider.score}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  color: Color(0xFFFFD700),
                                ),
                              ),
                              if (provider.streak >= 3)
                                Text(
                                  'STREAK x${provider.streak}',
                                  style: const TextStyle(
                                    color: Colors.orangeAccent,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Active Timer & Progress Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pertanyaan ${provider.currentQuestionIndex + 1}/${provider.questions.length}',
                          style: GoogleFonts.outfit(
                            color: Colors.white60,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              size: 14,
                              color: provider.secondsRemaining <= 5
                                  ? Colors.redAccent
                                  : Colors.white60,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${provider.secondsRemaining}s',
                              style: GoogleFonts.outfit(
                                color: provider.secondsRemaining <= 5
                                    ? Colors.redAccent
                                    : Colors.white60,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: provider.timerProgress,
                        backgroundColor: Colors.white.withOpacity(0.05),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          provider.secondsRemaining <= 5
                              ? Colors.redAccent
                              : const Color(0xFFFFD700),
                        ),
                        minHeight: 8,
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

  Widget _buildQuestionCard(
    BuildContext context,
    QuizProvider provider,
    dynamic question,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
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
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
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
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 220,
                              width: double.infinity,
                              color: Colors.white.withOpacity(0.05),
                              child: Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                  color: const Color(0xFFFFD700),
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              _buildImageError(),
                        )
                      : Image.asset(
                          question.imageUrl!,
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildImageError(),
                        ),
                ),
              ),
            ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Text(
              question.text,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Lifelines Buttons Row
          _buildLifelines(context, provider),
          
          // Options
          ...List.generate(
            question.options.length,
            (index) {
              if (provider.removedOptionIndices.contains(index)) {
                return const SizedBox.shrink(); // Hide eliminated option
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: _OptionButton(
                  index: index,
                  text: question.options[index],
                  isSelected: provider.selectedAnswerIndex == index,
                  isCorrect: index == question.correctAnswerIndex,
                  showResult: provider.isAnswering,
                  onTap: () => provider.answerQuestion(index),
                ),
              );
            },
          ),
          if (provider.isAnswering) ...[
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: provider.selectedAnswerIndex == null
                      ? Colors.redAccent.withOpacity(0.3)
                      : (provider.selectedAnswerIndex == question.correctAnswerIndex)
                          ? Colors.green.withOpacity(0.3)
                          : Colors.redAccent.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline_rounded,
                        color: provider.selectedAnswerIndex == null
                            ? Colors.redAccent
                            : (provider.selectedAnswerIndex == question.correctAnswerIndex)
                                ? Colors.greenAccent
                                : Colors.redAccent,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        provider.selectedAnswerIndex == null
                            ? 'Waktu Habis! Penjelasan:'
                            : (provider.selectedAnswerIndex == question.correctAnswerIndex)
                                ? 'Benar! Penjelasan:'
                                : 'Salah! Penjelasan:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: provider.selectedAnswerIndex == null
                              ? Colors.redAccent
                              : (provider.selectedAnswerIndex == question.correctAnswerIndex)
                                  ? Colors.greenAccent
                                  : Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    question.explanation.isEmpty || question.explanation.contains('Pertanyaan level')
                        ? 'Jawaban yang benar adalah "${question.options[question.correctAnswerIndex]}".'
                        : question.explanation,
                    style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8), height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () => provider.nextQuestionManual(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD700),
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            provider.currentQuestionIndex == provider.questions.length - 1
                                ? 'SELESAI'
                                : 'LANJUTKAN',
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, letterSpacing: 1),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded, size: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLifelines(BuildContext context, QuizProvider provider) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildLifelineButton(
            icon: Icons.brightness_medium_rounded,
            label: '50:50',
            isUsed: provider.isFiftyFiftyUsed,
            isEnabled: !provider.isAnswering && !provider.isGameOver,
            onTap: () => provider.useFiftyFifty(),
          ),
          _buildLifelineButton(
            icon: Icons.more_time_rounded,
            label: '+10s',
            isUsed: provider.isExtraTimeUsed,
            isEnabled: !provider.isAnswering && !provider.isGameOver,
            onTap: () => provider.useExtraTime(),
          ),
          _buildLifelineButton(
            icon: Icons.skip_next_rounded,
            label: 'Lewati',
            isUsed: provider.isSkipUsed,
            isEnabled: !provider.isAnswering && !provider.isGameOver,
            onTap: () => provider.useSkipQuestion(),
          ),
        ],
      ),
    );
  }

  Widget _buildLifelineButton({
    required IconData icon,
    required String label,
    required bool isUsed,
    required bool isEnabled,
    required VoidCallback onTap,
  }) {
    final activeColor = const Color(0xFFFFD700);
    return Opacity(
      opacity: isEnabled ? 1.0 : 0.5,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: isUsed
              ? Colors.white.withOpacity(0.01)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUsed
                ? Colors.white.withOpacity(0.05)
                : activeColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: InkWell(
          onTap: (isEnabled && !isUsed) ? onTap : null,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: isUsed ? Colors.white24 : activeColor,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: isUsed ? Colors.white24 : Colors.white,
                    decoration: isUsed ? TextDecoration.lineThrough : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageError() {
    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.grey.withOpacity(0.2),
      child: const Icon(
        Icons.image_not_supported,
        size: 50,
        color: Colors.white54,
      ),
    );
  }

  void _showQuitConfirmation(BuildContext context, QuizProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1D2136),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Keluar Kuis?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Apakah Anda yakin ingin keluar? Semua progres Anda akan hilang.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'LANJUTKAN',
              style: TextStyle(color: Color(0xFFFFD700)),
            ),
          ),
          TextButton(
            onPressed: () {
              provider.stopQuiz();
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to level screen
            },
            child: const Text(
              'KELUAR',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
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
        cardColor = Colors.green.withOpacity(0.6);
      } else if (isSelected && !isCorrect) {
        cardColor = Colors.red.withOpacity(0.6);
      }
    }

    return InkWell(
      onTap: showResult ? null : onTap,
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
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (showResult && isCorrect)
              const Icon(Icons.check_circle, color: Colors.white),
            if (showResult && isSelected && !isCorrect)
              const Icon(Icons.cancel, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
