import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/events.dart';

import 'obstacle.dart';
import '../stardy_game.dart';

class Player extends PositionComponent
    with DragCallbacks, CollisionCallbacks {

  Player({
    required Vector2 position,
  }) : super(
          position: position,
          size: Vector2.all(60),
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
      ..color = Colors.blue;

    canvas.drawRect(
      size.toRect(),
      paint,
    );
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    final game = findGame();

    if (game is StardyGame && game.isGameOver) {
      return;
    }

    position += event.localDelta;

    final gameSize = findGame()?.size;

    if (gameSize == null) {
      return;
    }

    final maxX = gameSize.x - size.x;
    final maxY = gameSize.y - size.y;

    position.x = position.x.clamp(0.0, maxX).toDouble();
    position.y = position.y.clamp(0.0, maxY).toDouble();
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(
      intersectionPoints,
      other,
    );

    if (other is Obstacle) {
      print('COLLISION!');

      final game = findGame();

      if (game is StardyGame) {
        game.gameOver();
      }
    }
  }
}