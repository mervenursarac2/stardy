import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameStateProvider extends ChangeNotifier {
  int _highScore = 0;
  bool _isSoundEnabled = true;

  int get highScore => _highScore;
  bool get isSoundEnabled => _isSoundEnabled;

  GameStateProvider() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _highScore = prefs.getInt('high_score') ?? 0;
    _isSoundEnabled = prefs.getBool('sound_enabled') ?? true;
    notifyListeners();
  }

  Future<void> updateScore(int score) async {
    if (score > _highScore) {
      _highScore = score;
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('high_score', _highScore);
    }
  }

  Future<void> toggleSound() async {
    _isSoundEnabled = !_isSoundEnabled;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound_enabled', _isSoundEnabled);
  }
}