import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/quiz_repository.dart';
import '../../providers/quiz_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'study_screen.dart';
import 'quiz_screen.dart';

class LevelScreen extends StatefulWidget {
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
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  @override
  void initState() {
    super.initState();
    // Load unlocked level in the next frame to prevent layout errors
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizProvider>().loadUnlockedLevelForCategory(widget.category);
    });
  }

  @override
  Widget build(BuildContext context) {
    final levelsCount = QuizRepository().getLevelsCountForCategory(widget.category);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          widget.isStudyMode ? 'Belajar ${widget.category}' : 'Kuis ${widget.category}',
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
        child: Consumer<QuizProvider>(
          builder: (context, provider, child) {
            final unlockedLevel = provider.unlockedLevel;

            return GridView.builder(
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
                // In study mode all levels are open. In quiz mode, check unlocked level index.
                final isLocked = !widget.isStudyMode && level > unlockedLevel;

                return _LevelCard(
                  level: level,
                  color: widget.categoryColor,
                  isLocked: isLocked,
                  onTap: () {
                    if (isLocked) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Selesaikan level ${level - 1} terlebih dahulu untuk membuka level ini!',
                            style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: Colors.redAccent.withOpacity(0.95),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      );
                    } else {
                      if (widget.isStudyMode) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudyScreen(
                              category: widget.category,
                              level: level,
                              categoryColor: widget.categoryColor,
                            ),
                          ),
                        );
                      } else {
                        context.read<QuizProvider>().startQuiz(widget.category, level);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const QuizScreen()),
                        );
                      }
                    }
                  },
                );
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
  final bool isLocked;
  final VoidCallback onTap;

  const _LevelCard({
    required this.level,
    required this.color,
    required this.isLocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayColor = isLocked ? Colors.white24 : color;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: displayColor.withOpacity(isLocked ? 0.02 : 0.15),
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
                colors: isLocked
                    ? [
                        Colors.white.withOpacity(0.05),
                        Colors.white.withOpacity(0.01),
                      ]
                    : [
                        color.withOpacity(0.2),
                        color.withOpacity(0.05),
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: isLocked ? Colors.white.withOpacity(0.05) : color.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLocked) ...[
                  const Icon(
                    Icons.lock_outline_rounded,
                    size: 30,
                    color: Colors.white24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'KUNCI',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                      color: Colors.white24,
                      letterSpacing: 1.2,
                    ),
                  ),
                ] else ...[
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
