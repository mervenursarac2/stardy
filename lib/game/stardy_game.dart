import 'package:flame/game.dart';
import 'package:flame/components.dart';

import 'components/player.dart';
import 'components/obstacle_spawner.dart';

class StardyGame extends FlameGame
    with HasCollisionDetection {

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
}