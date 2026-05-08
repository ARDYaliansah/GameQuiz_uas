import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/quiz_provider.dart';
import 'home_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<QuizProvider>();
    final score = provider.score;
    final isWin = provider.lives > 0;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A0E21), Color(0xFF1D2136)],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (isWin ? const Color(0xFFFFD700) : Colors.redAccent).withValues(alpha: 0.1),
                  boxShadow: [
                    BoxShadow(
                      color: (isWin ? const Color(0xFFFFD700) : Colors.redAccent).withValues(alpha: 0.2),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  isWin ? Icons.emoji_events_rounded : Icons.sentiment_very_dissatisfied_rounded,
                  size: 80,
                  color: isWin ? const Color(0xFFFFD700) : Colors.redAccent,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                isWin ? 'EXCELLENT!' : 'TRY AGAIN!',
                style: GoogleFonts.outfit(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  isWin ? 'You have successfully completed the quiz with a great score!' : 'Don\'t give up! Keep practicing to improve your knowledge.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(fontSize: 16, color: Colors.white70, fontWeight: FontWeight.w300),
                ),
              ),
              const SizedBox(height: 50),
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
                      'TOTAL SCORE',
                      style: GoogleFonts.outfit(fontSize: 14, letterSpacing: 3, fontWeight: FontWeight.w600, color: Colors.white54),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$score',
                      style: GoogleFonts.outfit(fontSize: 72, fontWeight: FontWeight.w900, color: const Color(0xFFFFD700)),
                    ),
                    Text(
                      'POINTS',
                      style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFFFFD700).withValues(alpha: 0.6)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          final firstQuestion = provider.questions.first;
                          provider.startQuiz(firstQuestion.category, firstQuestion.level);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFD700),
                          foregroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Text('REPLAY QUIZ', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1)),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: TextButton(
                        onPressed: () => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                          (route) => false,
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                          ),
                        ),
                        child: const Text('GO TO HOME', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, letterSpacing: 1)),
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
}
