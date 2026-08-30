import 'package:flutter/material.dart';
import '../game/stardy_game.dart';

class GameOverOverlay extends StatefulWidget {
  final StardyGame game;

  const GameOverOverlay({
    super.key,
    required this.game,
  });

  @override
  State<GameOverOverlay> createState() => _GameOverOverlayState();
}

class _GameOverOverlayState extends State<GameOverOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _flickerController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    // Hızlı ve belirgin LED titreşimi / yanıp sönme kontrolcüsü
    _flickerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });

    _glowAnimation = Tween<double>(begin: 0.15, end: 1.0).animate(
      CurvedAnimation(
        parent: _flickerController,
        curve: Curves.easeInOutQuad,
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
      backgroundColor: Colors.black.withOpacity(0.85),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ==========================================
                // LED BLINKING "MISSION FAILED" TITLE
                // ==========================================
                Text(
                  'MISSION\nFAILED',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.lerp(
                      const Color(0xFF5A0004),
                      const Color(0xFFFF1E27),
                      glowVal,
                    ),
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 5,
                    height: 1.05,
                    shadows: [
                      Shadow(
                        color: const Color(0xFFFF0015).withOpacity(glowVal),
                        blurRadius: 30 * glowVal,
                      ),
                      Shadow(
                        color: const Color(0xFFFF0015).withOpacity(glowVal * 0.8),
                        blurRadius: 10 * glowVal,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'HULL INTEGRITY COMPROMISED',
                  style: TextStyle(
                    color: const Color(0xFFD4C0D7).withOpacity(0.7),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),

                const SizedBox(height: 28),

                // ==========================================
                // STATS PANEL (GRID BACKGROUND CARD)
                // ==========================================
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 340),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141724).withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.08),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _GridPatternPainter(),
                        ),
                      ),
                      Column(
                        children: [
                          const Text(
                            'TOPLAM STARPUAN',
                            style: TextStyle(
                              color: Color(0xFF8E92A8),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _formatLargeNumber(widget.game.score),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 46,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // ==========================================
                // ACTION BUTTONS
                // ==========================================
                _NeonMenuButton(
                  text: 'PLAY AGAIN',
                  icon: Icons.refresh_rounded,
                  borderColor: const Color(0xFFBC13FE),
                  onPressed: () {
                    widget.game.restartGame();
                  },
                ),

                const SizedBox(height: 14),

                _NeonMenuButton(
                  text: 'RETURN TO BASE',
                  icon: Icons.home_rounded,
                  borderColor: const Color(0xFF00F2FF),
                  onPressed: () {
                    widget.game.returnToMainMenu();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatLargeNumber(int score) {
    final str = score.toString();
    if (str.length <= 3) return str;
    return str.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}

// ==================================================
// NEON OUTLINED ACTION BUTTON
// ==================================================
class _NeonMenuButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color borderColor;
  final VoidCallback onPressed;

  const _NeonMenuButton({
    required this.text,
    required this.icon,
    required this.borderColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 340),
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(0.35),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFF11131D).withOpacity(0.85),
          side: BorderSide(color: borderColor, width: 1.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: borderColor, size: 20),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================================================
// GRID BACKGROUND PAINTER
// ==================================================
class _GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..strokeWidth = 1.0;

    const step = 20.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}