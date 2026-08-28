import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';

class Player extends PositionComponent with DragCallbacks {
  Player({
    required Vector2 position,
  }) : super(
          position: position,
          size: Vector2(80, 80),
        );

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final paint = Paint()
      ..color = const Color(0xFF4FC3F7);

    canvas.drawRect(size.toRect(), paint);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    position += event.localDelta;
  }
}