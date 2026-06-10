import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _highScoreKey = 'high_score';

  Future<void> saveHighScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    final currentHigh = await getHighScore();
    if (score > currentHigh) {
      await prefs.setInt(_highScoreKey, score);
    }
  }

  Future<int> getHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_highScoreKey) ?? 0;
  }

  Future<void> saveUnlockedLevel(String category, int level) async {
    final prefs = await SharedPreferences.getInstance();
    final currentUnlocked = await getUnlockedLevel(category);
    if (level > currentUnlocked) {
      await prefs.setInt('unlocked_level_$category', level);
    }
  }

  Future<int> getUnlockedLevel(String category) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('unlocked_level_$category') ?? 1; // Default to level 1 unlocked
  }
}
