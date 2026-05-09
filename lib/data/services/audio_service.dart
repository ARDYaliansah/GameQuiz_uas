import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _effectPlayer = AudioPlayer();

  bool _isSoundEnabled = true;
  bool _isVibrationEnabled = true;

  bool get isSoundEnabled => _isSoundEnabled;
  bool get isVibrationEnabled => _isVibrationEnabled;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isSoundEnabled = prefs.getBool('sound_enabled') ?? true;
    _isVibrationEnabled = prefs.getBool('vibration_enabled') ?? true;

    _musicPlayer.setReleaseMode(ReleaseMode.loop);
  }

  Future<void> toggleSound(bool enabled) async {
    _isSoundEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound_enabled', enabled);

    if (!enabled) {
      await stopBackgroundMusic();
    } else {
      // If we are in a screen that needs music, it should be started by that screen
    }
  }

  Future<void> toggleVibration(bool enabled) async {
    _isVibrationEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('vibration_enabled', enabled);
  }

  Future<void> playBackgroundMusic() async {
    if (!_isSoundEnabled) return;
    try {
      await _musicPlayer.play(
        AssetSource('sounds/background.wav'),
        volume: 0.3,
      );
    } catch (e) {
      print("Error playing background music: $e");
    }
  }

  Future<void> stopBackgroundMusic() async {
    await _musicPlayer.stop();
  }

  Future<void> playCorrectSound() async {
    if (!_isSoundEnabled) return;
    try {
      await _effectPlayer.play(AssetSource('sounds/correct.wav'));
    } catch (e) {
      print("Error playing correct sound: $e");
    }
  }

  Future<void> playWrongSound() async {
    if (!_isSoundEnabled) return;
    try {
      await _effectPlayer.play(AssetSource('sounds/wrong.wav'));
    } catch (e) {
      print("Error playing wrong sound: $e");
    }
  }

  Future<void> vibrate() async {
    if (!_isVibrationEnabled) return;
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 500);
    }
  }
}
