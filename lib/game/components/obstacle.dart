import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/collisions.dart';
import '../stardy_game.dart';

class Obstacle extends SpriteComponent with HasGameRef<StardyGame> {
  final Random random = Random();
  late final double speed;
  late final double rotationSpeed;

  Obstacle({
    required Vector2 position,
  }) : super(
          position: position,
          size: Vector2(56, 56),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // images/meteor.png görselini yüklüyoruz
    sprite = await gameRef.loadSprite('meteor.png');

    // Netlik ve yumuşatma ayarları
    paint.filterQuality = FilterQuality.high;
    paint.isAntiAlias = true;

    // Rastgele düşüş hızı ve dönme hızı
    speed = 220 + random.nextDouble() * 90;
    rotationSpeed = (random.nextBool() ? 1 : -1) * (1.5 + random.nextDouble() * 2.0);

    // Çarpışma alanı (Dairesel Hitbox)
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

    // Aşağı düşüş
    position.y += speed * dt;

    // Kendi etrafında fütüristik dönüş
    angle += rotationSpeed * dt;

    // Ekranın altından çıkınca bellekten temizleme
    if (position.y > gameRef.size.y + 100) {
      removeFromParent();
    }
  }
}