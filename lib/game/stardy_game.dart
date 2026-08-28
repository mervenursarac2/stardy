import 'package:flame/game.dart';
import 'package:flame/components.dart';

import 'components/player.dart';
import 'components/obstacle_spawner.dart';

enum GameState {
  playing,
  gameOver,
}

class StardyGame extends FlameGame
    with HasCollisionDetection {

  GameState gameState = GameState.playing;

  bool get isGameOver => gameState == GameState.gameOver;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

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
  }

  void gameOver() {
    if (isGameOver) return;

    gameState = GameState.gameOver;

    pauseEngine();

    print('GAME OVER');
  }
}