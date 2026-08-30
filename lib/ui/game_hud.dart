import 'package:flutter/material.dart';
import '../game/stardy_game.dart';

class GameHud extends StatelessWidget {
  final StardyGame game;

  const GameHud({
    super.key,
    required this.game,
  });

  static const Color cyan = Color(0xFF00F2FF);
  static const Color textMuted = Color(0xFFD4C0D7);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: game.hudNotifier,
      builder: (context, _, __) {
        return SafeArea(
          child: Stack(
            children: [
              // =========================================
              // TOP BAR: DISTANCE & PAUSE
              // =========================================
              Positioned(
                top: 16,
                left: 20,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Distance HUD Panel
                    _HudChamferPanel(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'DISTANCE',
                            style: TextStyle(
                              color: textMuted,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                game.score.toString().padLeft(4, '0'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1,
                                  fontFamily: 'monospace',
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'M',
                                style: TextStyle(
                                  color: cyan,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Pause Button
                    GestureDetector(
                      onTap: () => game.togglePause(),
                      child: Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF191B26).withOpacity(0.65),
                          border: Border.all(
                            color: cyan,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: cyan.withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.pause_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ==================================================
// HUD CHAMFER CUT PANEL
// ==================================================
class _HudChamferPanel extends StatelessWidget {
  final Widget child;

  const _HudChamferPanel({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _ChamferClipper(cutSize: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          border: Border.all(
            color: const Color(0xFF00F2FF).withOpacity(0.3),
            width: 1.2,
          ),
        ),
        child: child,
      ),
    );
  }
}

class _ChamferClipper extends CustomClipper<Path> {
  final double cutSize;
  _ChamferClipper({this.cutSize = 10});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(cutSize, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - cutSize);
    path.lineTo(size.width - cutSize, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, cutSize);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}