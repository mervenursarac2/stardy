import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/game_state_provider.dart';
import 'arcade_hub.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

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
                  // Üst Bar (High Score kaldırıldı, System Online & Ses Butonu korundu)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => stateProvider.toggleSound(),
                        icon: Icon(
                          stateProvider.isSoundEnabled
                              ? Icons.volume_up_rounded
                              : Icons.volume_off_rounded,
                          color: cyan.withOpacity(0.8),
                          size: 22,
                        ),
                      ),
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

                  const Spacer(),

                  // Orta Başlık & İkon
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

                  const Text(
                    'STAR SPACE WORRIER',
                    style: TextStyle(
                      color: cyan,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // START Butonu -> ArcadeHub'a Yönlendirir
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ArcadeHub()),
                        );
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
                            'START',
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