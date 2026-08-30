import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/collisions.dart';

import '../stardy_game.dart';

class Obstacle extends PositionComponent
    with HasGameRef<StardyGame> {
  final Random random = Random();

  late final double speed;

  Obstacle({
    required Vector2 position,
  }) : super(
          position: position,
          size: Vector2(60, 60),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    speed = 220 + random.nextDouble() * 80;

    // Collision
    add(
      CircleHitbox(
        radius: 25,
        position: Vector2(5, 5),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!gameRef.isPlaying) return;

    position.y += speed * dt;

    // Ekrandan çıktıysa sil.
    if (position.y > gameRef.size.y + 100) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final center = Offset(
      size.x / 2,
      size.y / 2,
    );

    // ==========================================
    // METEOR GLOW
    // ==========================================

    final glowPaint = Paint()
      ..color = const Color(0xFFBC13FE).withOpacity(0.25)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        12,
      );

    canvas.drawCircle(
      center,
      24,
      glowPaint,
    );

    // ==========================================
    // METEOR BODY
    // ==========================================

    final bodyPaint = Paint()
      ..color = const Color(0xFF55586A)
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(30, 4);
    path.lineTo(45, 10);
    path.lineTo(55, 25);
    path.lineTo(50, 43);
    path.lineTo(35, 55);
    path.lineTo(17, 51);
    path.lineTo(5, 37);
    path.lineTo(8, 20);
    path.lineTo(18, 8);
    path.close();

    canvas.drawPath(path, bodyPaint);

    // ==========================================
    // METEOR EDGE
    // ==========================================

    final edgePaint = Paint()
      ..color = const Color(0xFF9EA3B8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(
      path,
      edgePaint,
    );

    // ==========================================
    // ROCK DETAILS
    // ==========================================

    final detailPaint = Paint()
      ..color = const Color(0xFF2B2E3A)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      const Offset(20, 24),
      5,
      detailPaint,
    );

    canvas.drawCircle(
      const Offset(38, 18),
      4,
      detailPaint,
    );

    canvas.drawCircle(
      const Offset(39, 39),
      6,
      detailPaint,
    );

    canvas.drawCircle(
      const Offset(18, 40),
      3,
      detailPaint,
    );

    // ==========================================
    // NEON CRACK
    // ==========================================

    final crackPaint = Paint()
      ..color = const Color(0xFF00F2FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final crack = Path();

    crack.moveTo(29, 8);
    crack.lineTo(26, 19);
    crack.lineTo(31, 27);
    crack.lineTo(26, 35);
    crack.lineTo(29, 46);

    canvas.drawPath(
      crack,
      crackPaint,
    );
  }
}