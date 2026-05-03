import 'package:flutter/material.dart';
import 'category_screen.dart';
import '../../data/services/storage_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final StorageService storage = StorageService();

    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F0C29), Color(0xFF302B63)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.stars_rounded, size: 80, color: Colors.amber),
            const SizedBox(height: 20),
            Text(
              'Welcome Back!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            _buildMenuButton(
              context,
              'PLAY GAME',
              Icons.play_arrow_rounded,
              Colors.greenAccent,
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoryScreen())),
            ),
            const SizedBox(height: 20),
            _buildMenuButton(
              context,
              'HIGH SCORE',
              Icons.emoji_events_rounded,
              Colors.amberAccent,
              () async {
                int highScore = await storage.getHighScore();
                if (context.mounted) {
                  _showHighScoreDialog(context, highScore);
                }
              },
            ),
            const SizedBox(height: 20),
            _buildMenuButton(
              context,
              'SETTINGS',
              Icons.settings_rounded,
              Colors.blueAccent,
              () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.black87),
        label: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
        ),
      ),
    );
  }

  void _showHighScoreDialog(BuildContext context, int score) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Global High Score'),
        content: Text('Your highest score is: $score', style: const TextStyle(fontSize: 20)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CLOSE')),
        ],
      ),
    );
  }
}
