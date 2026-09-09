import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

const int rowCount = 20;
const int colCount = 10;

enum Tetromino { L, J, I, O, S, Z, T }

class TetrisScreen extends StatefulWidget {
  const TetrisScreen({super.key});

  @override
  State<TetrisScreen> createState() => _TetrisScreenState();
}

class _TetrisScreenState extends State<TetrisScreen> with TickerProviderStateMixin {
  List<List<Color?>> board = List.generate(rowCount, (_) => List.filled(colCount, null));
  List<Point<int>> currentPiece = [];
  Tetromino currentType = Tetromino.I;
  Timer? gameTimer;
  int score = 0;
  bool isGameOver = false;
  bool isPaused = false;

  late final AnimationController _blinkController;
  late final Animation<double> _blinkAnimation;

  final Map<Tetromino, Color> pieceColors = {
    Tetromino.I: const Color(0xFF00F2FF),
    Tetromino.O: const Color(0xFFFFE600),
    Tetromino.T: const Color(0xFFBC13FE),
    Tetromino.S: const Color(0xFF00FF66),
    Tetromino.Z: const Color(0xFFFF0055),
    Tetromino.J: const Color(0xFF0066FF),
    Tetromino.L: const Color(0xFFFF8800),
  };

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
    _blinkAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _blinkController, curve: Curves.easeInOut),
    );

    startGame();
  }

  @override
  void dispose() {
    _blinkController.dispose();
    gameTimer?.cancel();
    super.dispose();
  }

  void startGame() {
    setState(() {
      board = List.generate(rowCount, (_) => List.filled(colCount, null));
      score = 0;
      isGameOver = false;
      isPaused = false;
    });
    spawnPiece();
    gameTimer?.cancel();
    gameTimer = Timer.periodic(const Duration(milliseconds: 450), (timer) {
      if (!isPaused && !isGameOver) {
        stepDown();
      }
    });
  }

  void spawnPiece() {
    final types = Tetromino.values;
    currentType = types[Random().nextInt(types.length)];
    switch (currentType) {
      case Tetromino.I:
        currentPiece = [const Point(0, 3), const Point(0, 4), const Point(0, 5), const Point(0, 6)];
        break;
      case Tetromino.O:
        currentPiece = [const Point(0, 4), const Point(0, 5), const Point(1, 4), const Point(1, 5)];
        break;
      case Tetromino.T:
        currentPiece = [const Point(0, 4), const Point(1, 3), const Point(1, 4), const Point(1, 5)];
        break;
      case Tetromino.S:
        currentPiece = [const Point(0, 4), const Point(0, 5), const Point(1, 3), const Point(1, 4)];
        break;
      case Tetromino.Z:
        currentPiece = [const Point(0, 3), const Point(0, 4), const Point(1, 4), const Point(1, 5)];
        break;
      case Tetromino.J:
        currentPiece = [const Point(0, 3), const Point(1, 3), const Point(1, 4), const Point(1, 5)];
        break;
      case Tetromino.L:
        currentPiece = [const Point(0, 5), const Point(1, 3), const Point(1, 4), const Point(1, 5)];
        break;
    }

    if (checkCollision(currentPiece)) {
      setState(() {
        isGameOver = true;
      });
      gameTimer?.cancel();
    }
  }

  bool checkCollision(List<Point<int>> piece) {
    for (var p in piece) {
      if (p.x < 0 || p.x >= rowCount || p.y < 0 || p.y >= colCount) return true;
      if (board[p.x][p.y] != null) return true;
    }
    return false;
  }

  void stepDown() {
    final moved = currentPiece.map((p) => Point(p.x + 1, p.y)).toList();
    if (!checkCollision(moved)) {
      setState(() => currentPiece = moved);
    } else {
      setState(() {
        for (var p in currentPiece) {
          board[p.x][p.y] = pieceColors[currentType];
        }
        clearLines();
        spawnPiece();
      });
    }
  }

  void moveLeft() {
    if (isPaused || isGameOver) return;
    final moved = currentPiece.map((p) => Point(p.x, p.y - 1)).toList();
    if (!checkCollision(moved)) setState(() => currentPiece = moved);
  }

  void moveRight() {
    if (isPaused || isGameOver) return;
    final moved = currentPiece.map((p) => Point(p.x, p.y + 1)).toList();
    if (!checkCollision(moved)) setState(() => currentPiece = moved);
  }

  void rotate() {
    if (isPaused || isGameOver || currentType == Tetromino.O) return;
    final pivot = currentPiece[1];
    final rotated = currentPiece.map((p) {
      final dx = p.x - pivot.x;
      final dy = p.y - pivot.y;
      return Point(pivot.x + dy, pivot.y - dx);
    }).toList();

    if (!checkCollision(rotated)) setState(() => currentPiece = rotated);
  }

  void hardDrop() {
    if (isPaused || isGameOver) return;
    var moved = currentPiece;
    while (!checkCollision(moved.map((p) => Point(p.x + 1, p.y)).toList())) {
      moved = moved.map((p) => Point(p.x + 1, p.y)).toList();
    }
    setState(() {
      currentPiece = moved;
      stepDown();
    });
  }

  void clearLines() {
    int linesCleared = 0;
    for (int r = rowCount - 1; r >= 0; r--) {
      if (board[r].every((c) => c != null)) {
        board.removeAt(r);
        board.insert(0, List.filled(colCount, null));
        linesCleared++;
        r++;
      }
    }
    if (linesCleared > 0) {
      score += linesCleared * 100 * linesCleared;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0D17),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // Top Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF00F2FF)),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Column(
                        children: [
                          const Text(
                            'COSMIC TETRIS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                          ),
                          Text(
                            'STARPUAN: $score',
                            style: const TextStyle(
                              color: Color(0xFF00F2FF),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.pause_rounded, color: Color(0xFFBC13FE), size: 28),
                        onPressed: () => setState(() => isPaused = true),
                      ),
                    ],
                  ),
                ),

                // Game Board
                Expanded(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: colCount / rowCount,
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF131524),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF7042F8), width: 2),
                          boxShadow: [
                            BoxShadow(color: const Color(0xFFBC13FE).withOpacity(0.2), blurRadius: 16),
                          ],
                        ),
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: rowCount * colCount,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: colCount),
                          itemBuilder: (context, index) {
                            final r = index ~/ colCount;
                            final c = index % colCount;
                            Color? color = board[r][c];

                            if (currentPiece.any((p) => p.x == r && p.y == c)) {
                              color = pieceColors[currentType];
                            }

                            return Container(
                              margin: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: color ?? Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(2),
                                border: Border.all(
                                  color: color != null ? Colors.white.withOpacity(0.4) : Colors.white.withOpacity(0.04),
                                  width: 0.8,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                // Controls
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _CtrlBtn(icon: Icons.arrow_left_rounded, onPressed: moveLeft),
                          _CtrlBtn(icon: Icons.rotate_right_rounded, onPressed: rotate, color: const Color(0xFFBC13FE)),
                          _CtrlBtn(icon: Icons.arrow_right_rounded, onPressed: moveRight),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _CtrlBtn(icon: Icons.arrow_drop_down_rounded, onPressed: stepDown),
                          const SizedBox(width: 20),
                          _CtrlBtn(
                            icon: Icons.keyboard_double_arrow_down_rounded,
                            onPressed: hardDrop,
                            color: const Color(0xFFFF0055),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ==========================================
          // PAUSE OVERLAY (SPACE RUNNER İLE AYNI TASARIM)
          // ==========================================
          if (isPaused && !isGameOver)
            Container(
              color: Colors.black.withOpacity(0.82),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  decoration: BoxDecoration(
                    color: const Color(0xFF131524),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF00F2FF), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00F2FF).withOpacity(0.35),
                        blurRadius: 28,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Yanıp Sönen PAUSED LED Işığı
                      AnimatedBuilder(
                        animation: _blinkAnimation,
                        builder: (context, child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 9,
                                height: 9,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00F2FF).withOpacity(_blinkAnimation.value),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF00F2FF).withOpacity(_blinkAnimation.value),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'PAUSED',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(_blinkAnimation.value),
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 6,
                                  shadows: [
                                    Shadow(
                                      color: const Color(0xFF00F2FF).withOpacity(_blinkAnimation.value),
                                      blurRadius: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'SYSTEM SUSPENDED',
                        style: TextStyle(
                          color: Color(0xFF8E92A8),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // StarPuan Kutusu
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white.withOpacity(0.08)),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'CURRENT STARPUAN',
                              style: TextStyle(
                                color: Color(0xFF8E92A8),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              score.toString().padLeft(4, '0'),
                              style: const TextStyle(
                                color: Color(0xFF00F2FF),
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 26),

                      // Butonlar
                      _OverlayBtn(
                        text: 'RESUME',
                        color: const Color(0xFF00F2FF),
                        onPressed: () => setState(() => isPaused = false),
                      ),
                      const SizedBox(height: 12),
                      _OverlayBtn(
                        text: 'QUIT TO MENU',
                        color: const Color(0xFFFF0055),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // ==========================================
          // GAME OVER OVERLAY (MISSION FAILED)
          // ==========================================
          if (isGameOver)
            Container(
              color: Colors.black.withOpacity(0.88),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  decoration: BoxDecoration(
                    color: const Color(0xFF131524),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFF0055), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF0055).withOpacity(0.35),
                        blurRadius: 28,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'MISSION FAILED',
                        style: TextStyle(
                          color: Color(0xFFFF0055),
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 4,
                          shadows: [
                            Shadow(
                              color: Color(0xFFFF0055),
                              blurRadius: 18,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'SIGNAL LOST IN SECTOR',
                        style: TextStyle(
                          color: Color(0xFF8E92A8),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 22),

                      // StarPuan Kutusu
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white.withOpacity(0.08)),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'FINAL STARPUAN',
                              style: TextStyle(
                                color: Color(0xFF8E92A8),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              score.toString().padLeft(4, '0'),
                              style: const TextStyle(
                                color: Color(0xFF00F2FF),
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 26),

                      // Butonlar
                      _OverlayBtn(
                        text: 'PLAY AGAIN',
                        color: const Color(0xFFBC13FE),
                        onPressed: startGame,
                      ),
                      const SizedBox(height: 12),
                      _OverlayBtn(
                        text: 'RETURN TO BASE',
                        color: const Color(0xFFFF0055),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _OverlayBtn extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const _OverlayBtn({
    required this.text,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: color.withOpacity(0.12),
          side: BorderSide(color: color, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          shadowColor: color,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}

class _CtrlBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  const _CtrlBtn({
    required this.icon,
    required this.onPressed,
    this.color = const Color(0xFF00F2FF),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: const Color(0xFF131524),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1.5),
        boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8)],
      ),
      child: IconButton(icon: Icon(icon, color: Colors.white, size: 30), onPressed: onPressed),
    );
  }
}