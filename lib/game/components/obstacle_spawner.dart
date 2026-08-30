import 'dart:math';

import 'package:flame/components.dart';

import '../stardy_game.dart';
import 'obstacle.dart';

class ObstacleSpawner extends Component {
  final StardyGame game;

  final Random random = Random();

  double timer = 0;

  ObstacleSpawner(this.game);

  @override
  void update(double dt) {
    super.update(dt);

    // Oyun oynanmıyorsa hiçbir şey yapma.
    if (!game.isPlaying) return;

    timer += dt;

    // Her 1.5 saniyede bir obstacle oluştur.
    if (timer >= 1.5) {
      timer = 0;
      spawnObstacle();
    }
  }

  void spawnObstacle() {
    // Eğer oyun bu sırada bitmişse obstacle oluşturma.
    if (!game.isPlaying) return;

    const obstacleWidth = 60.0;
    const obstacleHeight = 60.0;
    const sideMargin = 40.0;

    final minX = sideMargin;

    final maxX =
        game.size.x - obstacleWidth - sideMargin;

    final x =
        minX + random.nextDouble() * (maxX - minX);

    final obstacle = Obstacle(
      position: Vector2(
        x,
        -obstacleHeight,
      ),
    );

    obstacle.size = Vector2(
      obstacleWidth,
      obstacleHeight,
    );

    game.add(obstacle);
  }
}