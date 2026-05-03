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
}
