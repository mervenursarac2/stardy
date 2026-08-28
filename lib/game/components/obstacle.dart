import 'package:flutter/material.dart';
import 'package:flame/components.dart';

class Obstacle extends PositionComponent {
  Obstacle({
    required Vector2 position,
    required Vector2 size,
  }) : super(
          position: position,
          size: size,
        );

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final paint = Paint()
      ..color = Colors.red;

    canvas.drawRect(
      size.toRect(),
      paint,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Obstacle yukarıdan aşağı hareket ediyor.
    position.y += 200 * dt;

    // Ekranın altından çıktıysa kaldır.
    if (position.y > 800) {
      removeFromParent();
    }
  }
}