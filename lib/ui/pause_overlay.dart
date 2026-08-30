import 'package:flutter/material.dart';
import '../game/stardy_game.dart';

class PauseOverlay extends StatefulWidget {
  final StardyGame game;

  const PauseOverlay({
    super.key,
    required this.game,
  });

  @override
  State<PauseOverlay> createState() => _PauseOverlayState();
}

class _PauseOverlayState extends State<PauseOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _flickerController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    // Mor neon LED lamba yanıp sönme kontrolcüsü
    _flickerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });

    _glowAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _flickerController,
        curve: Curves.easeInOutSine,
      ),
    );

    _flickerController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _flickerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final glowVal = _glowAnimation.value;

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.8),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 320,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
            decoration: BoxDecoration(
              color: const Color(0xFF131524).withOpacity(0.92),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF7042F8),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFBC13FE).withOpacity(0.25),
                  blurRadius: 25,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Stack(
              children: [
                // Köşe HUD Çerçeve Çizgileri
                Positioned.fill(
                  child: CustomPaint(
                    painter: _HudCornerPainter(),
                  ),
                ),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ==========================================
                    // LED BLINKING "PAUSED" TITLE
                    // ==========================================
                    Text(
                      'PAUSED',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.lerp(
                          const Color(0xFF6B0294),
                          const Color(0xFFE22AFF),
                          glowVal,
                        ),
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                        shadows: [
                          Shadow(
                            color: const Color(0xFFBC13FE).withOpacity(glowVal),
                            blurRadius: 25 * glowVal,
                          ),
                          Shadow(
                            color: const Color(0xFF00F2FF).withOpacity(glowVal * 0.5),
                            blurRadius: 10 * glowVal,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ==========================================
                    // SCORE BADGE
                    // ==========================================
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A101D),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: const Color(0xFF00F2FF),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00F2FF).withOpacity(0.3),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'SCORE',
                            style: TextStyle(
                              color: Color(0xFF00F2FF),
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatScore(widget.game.score),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ==========================================
                    // RESUME BUTTON
                    // ==========================================
                    _PauseButton(
                      text: 'Resume',
                      icon: Icons.play_arrow_rounded,
                      borderColor: const Color(0xFFBC13FE),
                      onPressed: () {
                        widget.game.togglePause();
                      },
                    ),

                    const SizedBox(height: 16),

                    // ==========================================
                    // QUIT TO MENU BUTTON
                    // ==========================================
                    _PauseButton(
                      text: 'Quit to Menu',
                      icon: Icons.exit_to_app_rounded,
                      borderColor: const Color(0xFF2A2E43),
                      textColor: const Color(0xFFD4C0D7),
                      onPressed: () {
                        widget.game.returnToMainMenu();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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

// ==================================================
// NEON PAUSE BUTTON
// ==================================================
class _PauseButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color borderColor;
  final Color textColor;
  final VoidCallback onPressed;

  const _PauseButton({
    required this.text,
    required this.icon,
    required this.borderColor,
    this.textColor = Colors.white,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAccent = borderColor != const Color(0xFF2A2E43);

    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        boxShadow: isAccent
            ? [
                BoxShadow(
                  color: borderColor.withOpacity(0.35),
                  blurRadius: 10,
                ),
              ]
            : null,
      ),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFF1B1E2E).withOpacity(0.85),
          side: BorderSide(color: borderColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 20),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================================================
// HUD CORNER BRACKET PAINTER
// ==================================================
class _HudCornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    const len = 14.0;

    // Sol Üst Köşe
    canvas.drawLine(const Offset(4, 4), const Offset(4 + len, 4), paint);
    canvas.drawLine(const Offset(4, 4), const Offset(4, 4 + len), paint);

    // Sağ Alt Köşe
    canvas.drawLine(Offset(size.width - 4, size.height - 4), Offset(size.width - 4 - len, size.height - 4), paint);
    canvas.drawLine(Offset(size.width - 4, size.height - 4), Offset(size.width - 4, size.height - 4 - len), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}