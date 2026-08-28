import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'components/player.dart';
import 'components/obstacle_spawner.dart';

class StardyGame extends FlameGame {
  late Player player;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    player = Player(
      position: Vector2(
        size.x / 2 - 30,
        size.y - 100,
      ),
    );

    add(player);

    add(ObstacleSpawner(this));
  }
}