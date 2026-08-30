import 'package:flame/game.dart';
import 'package:flame/components.dart';

import 'components/player.dart';
import 'components/obstacle_spawner.dart';
import 'components/obstacle.dart';

enum GameState {
  menu,
  playing,
  gameOver,
}

class StardyGame extends FlameGame with HasCollisionDetection {
  GameState gameState = GameState.menu;

  bool get isPlaying => gameState == GameState.playing;
  bool get isGameOver => gameState == GameState.gameOver;
  double score = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    pauseEngine();
  }

  // ==========================================
  // START GAME
  // ==========================================

  Future<void> startGame() async {
    // Her yeni oyundan önce motoru durdur.
    pauseEngine();

    // Önce eski oyunu tamamen temizle.
    await _clearGame();

    // State'i playing yap.
    score = 0;
    gameState = GameState.playing;

    // Yeni Player.
    add(
      Player(
        position: Vector2(
          size.x / 2 - 30,
          size.y - 120,
        ),
      ),
    );

    // Yeni ObstacleSpawner.
    add(
      ObstacleSpawner(this),
    );

    // Overlay'leri düzenle.
    overlays.remove('MainMenu');
    overlays.remove('GameOver');
    overlays.add('GameHud');

    // Yeni oyunu başlat.
    resumeEngine();

    print('NEW GAME STARTED');
  }

  // ==========================================
  // GAME OVER
  // ==========================================

  void gameOver() {
    // Zaten Game Over ise tekrar çalıştırma.
    if (!isPlaying) return;

    gameState = GameState.gameOver;

    // Oyunun fizik/update döngüsünü durdur.
    pauseEngine();

    overlays.remove('GameHud');
    overlays.add('GameOver');

    print('GAME OVER');
  }

  // ==========================================
  // PLAY AGAIN
  // ==========================================

  Future<void> restartGame() async {
    // Motoru durdur.
    pauseEngine();

    // Eski oyunu tamamen temizle.
    await _clearGame();

    // Yeni oyun state'i.
    score = 0;
    gameState = GameState.playing;

    // Yeni Player.
    add(
      Player(
        position: Vector2(
          size.x / 2 - 30,
          size.y - 120,
        ),
      ),
    );

    // Yeni ObstacleSpawner.
    add(
      ObstacleSpawner(this),
    );

    // Overlay'leri düzenle.
    overlays.remove('GameOver');
    overlays.remove('MainMenu');
    overlays.add('GameHud');

    // Yeni oyunu başlat.
    resumeEngine();

    print('GAME RESTARTED');
  }

  // ==========================================
  // MAIN MENU
  // ==========================================

  Future<void> returnToMainMenu() async {
    // Motoru hemen durdur.
    pauseEngine();

    // Oyundaki bütün componentleri temizle.
    await _clearGame();

    // State artık menu.
    gameState = GameState.menu;

    // Overlay'leri düzenle.
    overlays.remove('GameOver');
    overlays.remove('GameHud');
    overlays.add('MainMenu');

    print('RETURNED TO MAIN MENU');
  }

  // ==========================================
  // CLEAR GAME
  // ==========================================

  Future<void> _clearGame() async {
    // Player'ları bul.
    final players = children.whereType<Player>().toList();

    // Spawner'ları bul.
    final spawners =
        children.whereType<ObstacleSpawner>().toList();

    // Obstacle'ları bul.
    final obstacles =
        children.whereType<Obstacle>().toList();

    // Hepsini kaldır.
    removeAll([
      ...players,
      ...spawners,
      ...obstacles,
    ]);

    print(
      'GAME CLEARED: '
      '${players.length} player, '
      '${spawners.length} spawner, '
      '${obstacles.length} obstacles',
    );
  }
  @override
  void update(double dt) {
    super.update(dt);

    if (!isPlaying) return;

    score += dt;
  }
}