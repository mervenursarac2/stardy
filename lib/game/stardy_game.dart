
import 'package:flame/game.dart';
import 'package:flame/components.dart';

import 'components/player.dart';
import 'components/obstacle_spawner.dart';
import 'components/obstacle.dart';

enum GameState {
  menu,
  playing,
  gameOver,
}

class StardyGame extends FlameGame with HasCollisionDetection {
  GameState gameState = GameState.menu;

  bool get isPlaying => gameState == GameState.playing;
  bool get isGameOver => gameState == GameState.gameOver;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Oyun başlangıçta çalışmayacak.
    // Sadece MainMenu gösterilecek.
    pauseEngine();
  }

  // ==========================================
  // START GAME
  // ==========================================

  void startGame() {
    // Eski oyunun bütün componentlerini temizle.
    _clearGame();

    gameState = GameState.playing;

    // Player oluştur.
    add(
      Player(
        position: Vector2(
          size.x / 2 - 30,
          size.y - 120,
        ),
      ),
    );

    // Obstacle spawner oluştur.
    add(
      ObstacleSpawner(this),
    );

    // UI overlaylerini düzenle.
    overlays.remove('MainMenu');
    overlays.remove('GameOver');
    overlays.add('GameHud');

    // Oyunu başlat.
    resumeEngine();
  }

  // ==========================================
  // GAME OVER
  // ==========================================

  void gameOver() {
    if (!isPlaying) return;

    gameState = GameState.gameOver;

    pauseEngine();

    overlays.remove('GameHud');
    overlays.add('GameOver');

    print('GAME OVER');
  }

  // ==========================================
  // PLAY AGAIN
  // ==========================================

  void restartGame() {
    // Eski oyunu tamamen temizle.
    _clearGame();

    gameState = GameState.playing;

    // Yeni player.
    add(
      Player(
        position: Vector2(
          size.x / 2 - 30,
          size.y - 120,
        ),
      ),
    );

    // Yeni obstacle spawner.
    add(
      ObstacleSpawner(this),
    );

    // UI.
    overlays.remove('GameOver');
    overlays.remove('MainMenu');
    overlays.add('GameHud');

    // Yeni oyun başlat.
    resumeEngine();
  }

  // ==========================================
  // MAIN MENU
  // ==========================================

  void returnToMainMenu() {
    // Oyunu durdur.
    pauseEngine();

    // Eski oyun componentlerini temizle.
    _clearGame();

    // State'i menu yap.
    gameState = GameState.menu;

    // UI.
    overlays.remove('GameOver');
    overlays.remove('GameHud');
    overlays.add('MainMenu');
  }

  // ==========================================
  // CLEAR GAME
  // ==========================================

  void _clearGame() {
    // Player'ları temizle.
    children.whereType<Player>().forEach((player) {
      player.removeFromParent();
    });

    // Spawner'ları temizle.
    children.whereType<ObstacleSpawner>().forEach((spawner) {
      spawner.removeFromParent();
    });

    // Ekrandaki obstacle'ları temizle.
    children.whereType<Obstacle>().forEach((obstacle) {
      obstacle.removeFromParent();
    });
  }
}

