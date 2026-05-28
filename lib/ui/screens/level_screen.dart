import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/quiz_repository.dart';
import '../../providers/quiz_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'study_screen.dart';
import 'quiz_screen.dart';

class LevelScreen extends StatelessWidget {
  final String category;
  final Color categoryColor;
  final bool isStudyMode;

  const LevelScreen({
    super.key,
    required this.category,
    required this.categoryColor,
    this.isStudyMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final levelsCount = QuizRepository().getLevelsCountForCategory(category);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          isStudyMode ? 'Belajar $category' : 'Kuis $category',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A0E21), Color(0xFF1D2136)],
          ),
        ),
        child: GridView.builder(
          padding: const EdgeInsets.fromLTRB(20, 120, 20, 20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1,
          ),
          itemCount: levelsCount,
          itemBuilder: (context, index) {
            final level = index + 1;
            return _LevelCard(
              level: level,
              color: categoryColor,
              onTap: () {
                if (isStudyMode) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudyScreen(
                        category: category,
                        level: level,
                        categoryColor: categoryColor,
                      ),
                    ),
                  );
                } else {
                  context.read<QuizProvider>().startQuiz(category, level);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const QuizScreen()),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final int level;
  final Color color;
  final VoidCallback onTap;

  const _LevelCard({
    required this.level,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.2),
                  color.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: color.withOpacity(0.3), width: 1.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'LEVEL',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: color,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  '$level',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w900,
                    fontSize: 32,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
