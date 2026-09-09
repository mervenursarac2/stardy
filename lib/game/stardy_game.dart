import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';

import '../state/game_state_provider.dart';
import 'components/player.dart';
import 'components/obstacle_spawner.dart';
import 'components/obstacle.dart';

enum GameState {
  menu,
  playing,
  gameOver,
}

class StardyGame extends FlameGame with HasCollisionDetection {
  final GameStateProvider gameStateProvider;

  StardyGame({required this.gameStateProvider});

  GameState gameState = GameState.menu;

  double elapsedTime = 0;
  final ValueNotifier<double> hudNotifier = ValueNotifier<double>(0);

  int get score => (elapsedTime * 100).floor();
  double get plasmaPercent => 0.78;

  bool get isPlaying => gameState == GameState.playing;
  bool get isGameOver => gameState == GameState.gameOver;

  @override
  Color backgroundColor() => const Color(0xFF11131D);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // ==========================================
    // ASSET PRELOAD (ÖNBELLEKLEME)
    // ==========================================
    await images.loadAll([
      'rocket.png',
      'meteor.png',
    ]);

    // Dinamik Uzay ve Yıldız Arkaplanı
    add(_ProceduralSpaceParallax());

    pauseEngine();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isPlaying) {
      elapsedTime += dt;
      hudNotifier.value = elapsedTime;
    }
  }

  void startGame() {
    _clearGame();
    elapsedTime = 0;
    gameState = GameState.playing;

    add(
      Player(
        position: Vector2(
          size.x / 2,
          size.y - 140,
        ),
      ),
    );

    add(ObstacleSpawner(this));

    overlays.remove('MainMenu');
    overlays.remove('GameOver');
    overlays.remove('Pause');
    overlays.add('GameHud');

    resumeEngine();
  }

  void gameOver() {
    if (!isPlaying) return;

    gameState = GameState.gameOver;
    pauseEngine();

    // En yüksek skoru State Management üzerinden güncelle
    gameStateProvider.updateScore(score);

    overlays.remove('GameHud');
    overlays.add('GameOver');
  }

  void restartGame() {
    _clearGame();
    elapsedTime = 0;
    gameState = GameState.playing;

    add(
      Player(
        position: Vector2(
          size.x / 2,
          size.y - 140,
        ),
      ),
    );

    add(ObstacleSpawner(this));

    overlays.remove('GameOver');
    overlays.remove('MainMenu');
    overlays.remove('Pause');
    overlays.add('GameHud');

    resumeEngine();
  }

  void returnToMainMenu() {
    pauseEngine();
    _clearGame();
    elapsedTime = 0;
    gameState = GameState.menu;

    overlays.clear();
    if (buildContext != null) {
      Navigator.of(buildContext!).pop();
    }
  }

  void togglePause() {
    if (!isPlaying && gameState != GameState.playing) return;

    if (paused) {
      resumeEngine();
      overlays.remove('Pause');
    } else {
      pauseEngine();
      overlays.add('Pause');
    }
  }

  void _clearGame() {
    children.whereType<Player>().forEach((p) => p.removeFromParent());
    children.whereType<ObstacleSpawner>().forEach((s) => s.removeFromParent());
    children.whereType<Obstacle>().forEach((o) => o.removeFromParent());
    children.whereType<ParticleSystemComponent>().forEach((pt) => pt.removeFromParent());
  }
}

class _ProceduralSpaceParallax extends PositionComponent with HasGameRef<StardyGame> {
  final List<Vector2> _starsLayer1 = [];
  final List<Vector2> _starsLayer2 = [];
  final Random _rnd = Random();

  @override
  int get priority => -10;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    size = gameRef.size;

    for (int i = 0; i < 45; i++) {
      _starsLayer1.add(Vector2(_rnd.nextDouble() * size.x, _rnd.nextDouble() * size.y));
    }
    for (int i = 0; i < 25; i++) {
      _starsLayer2.add(Vector2(_rnd.nextDouble() * size.x, _rnd.nextDouble() * size.y));
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
  }

  @override
  void update(double dt) {
    super.update(dt);

    for (var s in _starsLayer1) {
      s.y += 80 * dt;
      if (s.y > size.y) {
        s.y = 0;
        s.x = _rnd.nextDouble() * size.x;
      }
    }

    for (var s in _starsLayer2) {
      s.y += 180 * dt;
      if (s.y > size.y) {
        s.y = 0;
        s.x = _rnd.nextDouble() * size.x;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final bgPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0, -0.4),
        radius: 1.2,
        colors: [
          const Color(0xFFBC13FE).withOpacity(0.18),
          const Color(0xFF00F2FF).withOpacity(0.06),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.x, size.y));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), bgPaint);

    final starPaint1 = Paint()..color = const Color(0xFFD4C0D7).withOpacity(0.5);
    for (var s in _starsLayer1) {
      canvas.drawCircle(Offset(s.x, s.y), 1.2, starPaint1);
    }

    final starPaint2 = Paint()
      ..color = const Color(0xFF00F2FF)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1);
    for (var s in _starsLayer2) {
      canvas.drawCircle(Offset(s.x, s.y), 1.8, starPaint2);
    }
  }
}