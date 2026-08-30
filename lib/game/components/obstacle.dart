import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/collisions.dart';
import '../stardy_game.dart';

class Obstacle extends SpriteComponent with HasGameRef<StardyGame> {
  final Random random = Random();
  final double speedMultiplier;
  late final double speed;
  late final double rotationSpeed;

  Obstacle({
    required Vector2 position,
    this.speedMultiplier = 1.0,
  }) : super(
          position: position,
          size: Vector2(56, 56),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite('meteor.png');
    paint.filterQuality = FilterQuality.high;
    paint.isAntiAlias = true;

    // Temel hız çarpanla çarpılarak hesaplanır
    final baseSpeed = 220 + random.nextDouble() * 80;
    speed = baseSpeed * speedMultiplier;

    rotationSpeed = (random.nextBool() ? 1 : -1) * (1.5 + random.nextDouble() * 2.0) * speedMultiplier;

    add(
      CircleHitbox(
        radius: size.x * 0.4,
        position: Vector2(size.x * 0.1, size.y * 0.1),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!gameRef.isPlaying) return;

    position.y += speed * dt;
    angle += rotationSpeed * dt;

    if (position.y > gameRef.size.y + 100) {
      removeFromParent();
    }
  }
}