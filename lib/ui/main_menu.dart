import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game/stardy_game.dart';
import '../state/game_state_provider.dart';

class MainMenu extends StatelessWidget {
  final StardyGame game;

  const MainMenu({
    super.key,
    required this.game,
  });

  static const Color background = Color(0xFF0B0D17);
  static const Color purple = Color(0xFFBC13FE);
  static const Color cyan = Color(0xFF00F2FF);
  static const Color textColor = Color(0xFFE1E1F0);

  @override
  Widget build(BuildContext context) {
    final stateProvider = context.watch<GameStateProvider>();

    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          // Background Glows
          Positioned(
            top: -100,
            left: -80,
            child: _GlowCircle(color: purple, size: 260),
          ),
          Positioned(
            bottom: -120,
            right: -80,
            child: _GlowCircle(color: cyan, size: 280),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  // ==========================================
                  // TOP BAR: SOUND BUTTON & CORNER HIGH SCORE
                  // ==========================================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sound Toggle Button
                      IconButton(
                        onPressed: () => stateProvider.toggleSound(),
                        icon: Icon(
                          stateProvider.isSoundEnabled ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                          color: cyan.withOpacity(0.8),
                          size: 22,
                        ),
                      ),

                      // Corner High Score & System Online
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ClipPath(
                            clipper: _CornerCutClipper(cutSize: 8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF191B28).withOpacity(0.88),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.12),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    'HIGH SCORE',
                                    style: TextStyle(
                                      color: Color(0xFF8E92A8),
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _formatScore(stateProvider.highScore),
                                    style: const TextStyle(
                                      color: Color(0xFFEBB2FF),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.8,
                                      fontFamily: 'monospace',
                                      shadows: [
                                        Shadow(
                                          color: purple,
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: cyan,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: cyan.withOpacity(0.8),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'SYSTEM ONLINE',
                                style: TextStyle(
                                  color: cyan,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  const Spacer(),

                  // ==========================================
                  // CENTER CONTENT
                  // ==========================================
                  // Neon Rocket Icon
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: purple.withOpacity(0.1),
                      boxShadow: [
                        BoxShadow(
                          color: purple.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.rocket_launch_rounded,
                      color: Color(0xFFEBB2FF),
                      size: 42,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Game Title
                  const Text(
                    'STARDY',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 5,
                      height: 1,
                      shadows: [
                        Shadow(color: purple, blurRadius: 25),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Subtitle
                  const Text(
                    'STAR SPACE RUNNER',
                    style: TextStyle(
                      color: cyan,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // START GAME BUTTON
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 280),
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: purple.withOpacity(0.35),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: OutlinedButton(
                      onPressed: () {
                        game.startGame();
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFF131524).withOpacity(0.85),
                        side: const BorderSide(color: purple, width: 1.8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_arrow_rounded, color: Colors.white, size: 22),
                          SizedBox(width: 8),
                          Text(
                            'START GAME',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Footer version info
                  const Text(
                    'MISSION CONTROL  •  v1.0',
                    style: TextStyle(
                      color: Color(0xFF7A7085),
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatScore(int score) {
    final str = score.toString();
    if (str.length <= 3) return str;
    return str.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}

class _CornerCutClipper extends CustomClipper<Path> {
  final double cutSize;
  _CornerCutClipper({this.cutSize = 8});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(cutSize, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, cutSize);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _GlowCircle extends StatelessWidget {
  final Color color;
  final double size;

  const _GlowCircle({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.035),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.18),
            blurRadius: 100,
            spreadRadius: 30,
          ),
        ],
      ),
    );
  }
}