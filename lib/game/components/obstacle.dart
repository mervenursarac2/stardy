import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

class Obstacle extends PositionComponent {
  Obstacle({
    required Vector2 position,
  }) : super(
          position: position,
          size: Vector2(60, 60),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(
      RectangleHitbox(),
    );
  }

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

    position.y += 200 * dt;

    if (position.y > findGame()!.size.y) {
      removeFromParent();
    }
  }
}