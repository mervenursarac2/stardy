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

  // ==============================
  // SCORE
  // ==============================

  double elapsedTime = 0;

  int get score => (elapsedTime * 100).floor();

  double get plasmaPercent {
    // Şimdilik görsel olarak 78%.
    // Daha sonra player'ın durumuna bağlayabiliriz.
    return 0.78;
  }

  bool get isPlaying => gameState == GameState.playing;
  bool get isGameOver => gameState == GameState.gameOver;

  // ==============================
  // LOAD
  // ==============================

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    pauseEngine();
  }

  // ==============================
  // UPDATE
  // ==============================

  @override
  void update(double dt) {
    super.update(dt);

    if (isPlaying) {
      elapsedTime += dt;
    }
  }

  // ==============================
  // START GAME
  // ==============================

  void startGame() {
    _clearGame();

    elapsedTime = 0;

    gameState = GameState.playing;

    add(
      Player(
        position: Vector2(
          size.x / 2 - 30,
          size.y - 120,
        ),
      ),
    );

    add(
      ObstacleSpawner(this),
    );

    overlays.remove('MainMenu');
    overlays.remove('GameOver');
    overlays.remove('Pause');
    overlays.add('GameHud');

    resumeEngine();
  }

  // ==============================
  // GAME OVER
  // ==============================

  void gameOver() {
    if (!isPlaying) return;

    gameState = GameState.gameOver;

    pauseEngine();

    overlays.remove('GameHud');
    overlays.add('GameOver');

    print('GAME OVER - SCORE: $score');
  }

  // ==============================
  // RESTART
  // ==============================

  void restartGame() {
    _clearGame();

    elapsedTime = 0;

    gameState = GameState.playing;

    add(
      Player(
        position: Vector2(
          size.x / 2 - 30,
          size.y - 120,
        ),
      ),
    );

    add(
      ObstacleSpawner(this),
    );

    overlays.remove('GameOver');
    overlays.remove('MainMenu');
    overlays.remove('Pause');
    overlays.add('GameHud');

    resumeEngine();
  }

  // ==============================
  // MAIN MENU
  // ==============================

  void returnToMainMenu() {
    pauseEngine();

    _clearGame();

    elapsedTime = 0;

    gameState = GameState.menu;

    overlays.remove('GameOver');
    overlays.remove('GameHud');
    overlays.remove('Pause');
    overlays.add('MainMenu');
  }

  // ==============================
  // PAUSE
  // ==============================

  void togglePause() {
    if (!isPlaying) return;

    if (paused) {
      resumeEngine();
      overlays.remove('Pause');
    } else {
      pauseEngine();
      overlays.add('Pause');
    }
  }

  // ==============================
  // CLEAR
  // ==============================

  void _clearGame() {
    children.whereType<Player>().forEach((player) {
      player.removeFromParent();
    });

    children.whereType<ObstacleSpawner>().forEach((spawner) {
      spawner.removeFromParent();
    });

    children.whereType<Obstacle>().forEach((obstacle) {
      obstacle.removeFromParent();
    });
  }
}