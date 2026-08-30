import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flame/particles.dart';

import 'obstacle.dart';
import '../stardy_game.dart';

class Player extends SpriteComponent
    with DragCallbacks, CollisionCallbacks, HasGameRef<StardyGame> {
  final Random _random = Random();
  double _particleTimer = 0;

  Player({
    required Vector2 position,
  }) : super(
          position: position,
          size: Vector2(54, 75), // Roket boyutu
          anchor: Anchor.center,
        );
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite('rocket.png');
    
    // Filtreleme ve kenar yumuşatma
    paint.filterQuality = FilterQuality.high;
    paint.isAntiAlias = true;

    // Genişliği 55 piksel yapıp yüksekliği görselin orijinal oranına göre hesaplar
    const targetWidth = 55.0;
    final aspectRatio = sprite!.srcSize.y / sprite!.srcSize.x;
    size = Vector2(targetWidth, targetWidth * aspectRatio);

    // Hitbox'ı yeni boyuta göre otomatik ortala
    add(
      RectangleHitbox(
        size: Vector2(size.x * 0.7, size.y * 0.8),
        position: Vector2(size.x * 0.15, size.y * 0.1),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!gameRef.isPlaying) return;

    // Roketin arkasından çıkan neon alev/egzoz partikülleri
    _particleTimer += dt;
    if (_particleTimer >= 0.03) {
      _particleTimer = 0;
      _spawnThrustParticles();
    }
  }

  void _spawnThrustParticles() {
    final particleSystem = ParticleSystemComponent(
      particle: Particle.generate(
        count: 3,
        lifespan: 0.35,
        generator: (i) {
          final isCyan = _random.nextBool();
          return AcceleratedParticle(
            acceleration: Vector2((_random.nextDouble() - 0.5) * 40, 260),
            speed: Vector2((_random.nextDouble() - 0.5) * 20, 110),
            position: position.clone() + Vector2(0, size.y / 2 - 6),
            child: CircleParticle(
              radius: 2.0 + _random.nextDouble() * 2.5,
              paint: Paint()
                ..color = isCyan
                    ? const Color(0xFF00F2FF).withOpacity(0.85)
                    : const Color(0xFFBC13FE).withOpacity(0.85)
                ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
            ),
          );
        },
      ),
    );

    gameRef.add(particleSystem);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (gameRef.isGameOver || !gameRef.isPlaying) return;

    position += event.localDelta;

    final maxX = gameRef.size.x - size.x / 2;
    final minX = size.x / 2;
    final maxY = gameRef.size.y - size.y / 2;
    final minY = size.y / 2;

    position.x = position.x.clamp(minX, maxX);
    position.y = position.y.clamp(minY, maxY);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Obstacle) {
      gameRef.gameOver();
    }
  }
}