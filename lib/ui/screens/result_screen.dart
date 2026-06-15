import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';
import '../../providers/quiz_provider.dart';
import 'home_screen.dart';
import 'study_screen.dart';
import 'quiz_screen.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 4));
    
    // Play confetti immediately if player won
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<QuizProvider>();
      final isWin = provider.lives > 0;
      if (isWin) {
        _confettiController.play();
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Color _getColor(String category) {
    switch (category) {
      case 'Teknologi':
        return const Color(0xFF00D2FF);
      case 'Sejarah':
        return const Color(0xFFFFD700);
      case 'Film':
        return const Color(0xFFFF4B2B);
      case 'Sains':
        return const Color(0xFF00FF87);
      case 'Tebak Gambar':
        return const Color(0xFF6C63FF);
      default:
        return const Color(0xFFFFD700);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<QuizProvider>();
    final score = provider.score;
    final isWin = provider.lives > 0;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Background Gradient and Content
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0A0E21), Color(0xFF1D2136)],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    // Trophy/Dissatisfied Icon with Animation
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.elasticOut,
                      builder: (context, val, child) {
                        return Transform.scale(
                          scale: val,
                          child: child,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (isWin ? const Color(0xFFFFD700) : Colors.redAccent).withValues(alpha: 0.12),
                          boxShadow: [
                            BoxShadow(
                              color: (isWin ? const Color(0xFFFFD700) : Colors.redAccent).withValues(alpha: 0.3),
                              blurRadius: 40,
                              spreadRadius: 8,
                            ),
                          ],
                        ),
                        child: Icon(
                          isWin ? Icons.emoji_events_rounded : Icons.sentiment_very_dissatisfied_rounded,
                          size: 90,
                          color: isWin ? const Color(0xFFFFD700) : Colors.redAccent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Festive Title Text
                    Text(
                      isWin ? '🎉 SELAMAT! 🎉' : 'COBA LAGI!',
                      style: GoogleFonts.outfit(
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                        color: isWin ? const Color(0xFFFFD700) : Colors.redAccent,
                        shadows: isWin
                            ? [
                                Shadow(
                                  color: const Color(0xFFFFD700).withValues(alpha: 0.4),
                                  blurRadius: 15,
                                  offset: const Offset(0, 0),
                                ),
                              ]
                            : [],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Message Subtitle
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 45),
                      child: Text(
                        isWin
                            ? 'Luar biasa! Kamu telah berhasil menyelesaikan kuis dengan hasil yang sangat baik!'
                            : 'Jangan berkecil hati! Teruslah belajar untuk meningkatkan pengetahuanmu.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          color: Colors.white70,
                          fontWeight: FontWeight.w300,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Score Card
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 30),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'TOTAL SKOR',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              letterSpacing: 3,
                              fontWeight: FontWeight.w600,
                              color: Colors.white54,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '$score',
                            style: GoogleFonts.outfit(
                              fontSize: 72,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFFFFD700),
                            ),
                          ),
                          Text(
                            'POIN',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFFFD700).withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Buttons Group
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: [
                          if (isWin && provider.hasNextLevel) ...[
                            SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: ElevatedButton(
                                onPressed: () {
                                  final nextLevel = provider.currentLevel! + 1;
                                  final category = provider.currentCategory!;
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StudyScreen(
                                        category: category,
                                        level: nextLevel,
                                        categoryColor: _getColor(category),
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFFD700),
                                  foregroundColor: Colors.black87,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 5,
                                ),
                                child: const Text(
                                  'LEVEL BERIKUTNYA',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                          ],
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () {
                                if (provider.currentCategory != null &&
                                    provider.currentLevel != null) {
                                  provider.startQuiz(
                                    provider.currentCategory!,
                                    provider.currentLevel!,
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const QuizScreen(),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isWin && provider.hasNextLevel
                                    ? Colors.white.withValues(alpha: 0.1)
                                    : const Color(0xFFFFD700),
                                foregroundColor: isWin && provider.hasNextLevel
                                    ? Colors.white
                                    : Colors.black87,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                side: isWin && provider.hasNextLevel
                                    ? BorderSide(color: Colors.white.withValues(alpha: 0.2))
                                    : BorderSide.none,
                              ),
                              child: const Text(
                                'ULANGI KUIS',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: TextButton(
                              onPressed: () => Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                                (route) => false,
                              ),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white70,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.1),
                                  ),
                                ),
                              ),
                              child: const Text(
                                'KEMBALI KE MENU',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  letterSpacing: 1,
                                ),
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
          ),
          // Confetti overlay on victory
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
                Color(0xFFFFD700),
              ],
              numberOfParticles: 35,
              gravity: 0.15,
            ),
          ),
        ],
      ),
    );
  }
}
