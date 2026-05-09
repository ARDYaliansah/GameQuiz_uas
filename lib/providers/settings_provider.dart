import 'package:flutter/material.dart';
import '../data/services/audio_service.dart';

class SettingsProvider with ChangeNotifier {
  final AudioService _audioService = AudioService();

  bool get isSoundEnabled => _audioService.isSoundEnabled;
  bool get isVibrationEnabled => _audioService.isVibrationEnabled;

  Future<void> toggleSound(bool value) async {
    await _audioService.toggleSound(value);
    notifyListeners();
  }

  Future<void> toggleVibration(bool value) async {
    await _audioService.toggleVibration(value);
    notifyListeners();
  }
}
