import 'dart:math';
import 'package:flame/components.dart';
import '../stardy_game.dart';
import 'obstacle.dart';

class ObstacleSpawner extends Component {
  final StardyGame game;
  final Random random = Random();
  double timer = 0;

  ObstacleSpawner(this.game);

  // Hız Çarpanı Hesabı:
  // - İlk 10 saniye: 1.0 (başlangıç hızı)
  // - 10. saniyeden sonra: Her 20 saniyede bir %25 hız artışı
  double get speedMultiplier {
    if (game.elapsedTime <= 10) {
      return 1.0;
    }
    final extraTime = game.elapsedTime - 10;
    final tiers = (extraTime / 20).floor();
    return 1.0 + (tiers * 0.25);
  }

  // Meteorların Çıkış Aralığı:
  // Başlangıçta 1.5 saniye, zorlaştıkça minimum 0.65 saniyeye kadar düşer.
  double get currentSpawnInterval {
    final interval = 1.5 / speedMultiplier;
    return interval.clamp(0.65, 1.5);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!game.isPlaying) return;

    timer += dt;

    if (timer >= currentSpawnInterval) {
      timer = 0;
      spawnObstacle();
    }
  }

  void spawnObstacle() {
    if (!game.isPlaying) return;

    const obstacleWidth = 56.0;
    const obstacleHeight = 56.0;
    const sideMargin = 30.0;

    final minX = sideMargin;
    final maxX = game.size.x - obstacleWidth - sideMargin;
    final x = minX + random.nextDouble() * (maxX - minX);

    final obstacle = Obstacle(
      position: Vector2(x, -obstacleHeight),
      speedMultiplier: speedMultiplier, // Güncel hız çarpanını iletiyoruz
    );

    game.add(obstacle);
  }
}