import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'category_screen.dart';
import '../../data/services/storage_service.dart';
import '../../providers/settings_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final StorageService storage = StorageService();

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A0E21), Color(0xFF1D2136)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              _buildHeader(),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    _buildMenuButton(
                      context,
                      'PLAY GAME',
                      Icons.play_arrow_rounded,
                      const Color(0xFFFFD700),
                      () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoryScreen())),
                    ),
                    const SizedBox(height: 15),
                    _buildMenuButton(
                      context,
                      'HIGH SCORE',
                      Icons.emoji_events_rounded,
                      const Color(0xFFE0E0E0),
                      () async {
                        int highScore = await storage.getHighScore();
                        if (context.mounted) {
                          _showHighScoreDialog(context, highScore);
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildMenuButton(
                      context,
                      'SETTINGS',
                      Icons.settings_rounded,
                      const Color(0xFFE0E0E0),
                      () => _showSettingsDialog(context),
                    ),
                    const SizedBox(height: 15),
                    _buildMenuButton(
                      context,
                      'EXIT',
                      Icons.exit_to_app_rounded,
                      const Color(0xFFFF5252),
                      () => _showExitConfirmation(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFFFD700).withOpacity(0.1),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFD700).withOpacity(0.2),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Icon(Icons.auto_awesome, size: 80, color: Color(0xFFFFD700)),
        ),
        const SizedBox(height: 30),
        Text(
          'GAME QUIZ',
          style: GoogleFonts.outfit(
            fontSize: 42,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            color: Colors.white,
          ),
        ),
        Text(
          'Sharpen Your Knowledge',
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            letterSpacing: 1,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    bool isPrimary = title == 'PLAY GAME';
    bool isExit = title == 'EXIT';
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: isPrimary ? [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ] : [],
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? color : isExit ? color.withOpacity(0.1) : Colors.white.withOpacity(0.05),
          foregroundColor: isPrimary ? Colors.black87 : isExit ? color : Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: isPrimary ? BorderSide.none : BorderSide(color: isExit ? color.withOpacity(0.3) : Colors.white.withOpacity(0.1)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 15),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, letterSpacing: 1),
            ),
          ],
        ),
      ),
    );
  }

  void _showHighScoreDialog(BuildContext context, int score) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1D2136),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('High Score', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFFFFD700))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events_rounded, size: 60, color: Color(0xFFFFD700)),
            const SizedBox(height: 20),
            Text('$score', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white)),
            const Text('Points', style: TextStyle(color: Colors.white70)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CLOSE', style: TextStyle(color: Color(0xFFFFD700))),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Consumer<SettingsProvider>(
        builder: (context, settings, child) => AlertDialog(
          backgroundColor: const Color(0xFF1D2136),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.settings_rounded, color: Color(0xFFFFD700)),
              SizedBox(width: 10),
              Text('Settings', style: TextStyle(color: Colors.white)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: const Text('Sound Effects', style: TextStyle(color: Colors.white)),
                subtitle: const Text('Play sounds during game', style: TextStyle(color: Colors.white70, fontSize: 12)),
                value: settings.isSoundEnabled,
                activeColor: const Color(0xFFFFD700),
                onChanged: (value) => settings.toggleSound(value),
              ),
              SwitchListTile(
                title: const Text('Vibration', style: TextStyle(color: Colors.white)),
                subtitle: const Text('Vibrate on wrong answers', style: TextStyle(color: Colors.white70, fontSize: 12)),
                value: settings.isVibrationEnabled,
                activeColor: const Color(0xFFFFD700),
                onChanged: (value) => settings.toggleVibration(value),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('DONE', style: TextStyle(color: Color(0xFFFFD700))),
            ),
          ],
        ),
      ),
    );
  }

  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1D2136),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Exit Game', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to exit the game?', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            onPressed: () {
              if (Platform.isAndroid || Platform.isIOS) {
                SystemNavigator.pop();
              } else {
                exit(0);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF5252), foregroundColor: Colors.white),
            child: const Text('EXIT'),
          ),
        ],
      ),
    );
  }
}
