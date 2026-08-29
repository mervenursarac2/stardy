import 'package:flutter/material.dart';

import '../game/stardy_game.dart';

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
    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          // Background glow
          Positioned(
            top: -100,
            left: -80,
            child: _GlowCircle(
              color: purple,
              size: 260,
            ),
          ),

          Positioned(
            bottom: -120,
            right: -80,
            child: _GlowCircle(
              color: cyan,
              size: 280,
            ),
          ),

          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 28,
              ),
              child: Column(
                children: [
                  // Top technical label
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: cyan,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: cyan.withOpacity(0.8),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'SYSTEM ONLINE',
                          style: TextStyle(
                            color: cyan,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Logo
                  const Text(
                    'STARDY',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 52,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 6,
                      height: 1,
                      shadows: [
                        Shadow(
                          color: purple,
                          blurRadius: 22,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  const Text(
                    'STAR SPACE RUNNER',
                    style: TextStyle(
                      color: cyan,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Decorative line
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 45,
                        height: 1,
                        color: purple,
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: purple,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: purple.withOpacity(0.9),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 45,
                        height: 1,
                        color: purple,
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Start button
                _NeonButton(
                    text: 'START GAME',
                    color: purple,
                    onPressed: () {
                    game.overlays.remove('MainMenu');
                    game.overlays.add('GameHud');

                    game.startGame();
                    game.resumeEngine();
                },
                ),

                  const SizedBox(height: 18),

                  // Secondary button
                  _NeonButton(
                    text: 'SETTINGS',
                    color: cyan,
                    outlined: true,
                    onPressed: () {
                      // Settings'i daha sonra ekleyeceğiz.
                    },
                  ),

                  const SizedBox(height: 35),

                  // Version / status
                  const Text(
                    'MISSION CONTROL  •  v1.0',
                    style: TextStyle(
                      color: Color(0xFF9D8BA0),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NeonButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;
  final bool outlined;

  const _NeonButton({
    required this.text,
    required this.color,
    required this.onPressed,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 54,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: outlined
              ? Colors.transparent
              : color.withOpacity(0.16),
          foregroundColor: Colors.white,
          side: BorderSide(
            color: color,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          shadowColor: color,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final Color color;
  final double size;

  const _GlowCircle({
    required this.color,
    required this.size,
  });

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