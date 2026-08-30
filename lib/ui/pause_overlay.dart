import 'package:flutter/material.dart';

import '../game/stardy_game.dart';

class PauseOverlay extends StatelessWidget {
  final StardyGame game;

  const PauseOverlay({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 260,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: const Color(0xFF0B0D17).withOpacity(0.96),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF00F2FF),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00F2FF).withOpacity(0.25),
              blurRadius: 25,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.pause,
              color: Color(0xFF00F2FF),
              size: 42,
            ),

            const SizedBox(height: 12),

            const Text(
              'GAME PAUSED',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  game.togglePause();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF00F2FF).withOpacity(0.15),
                  foregroundColor: Colors.white,
                  side: const BorderSide(
                    color: Color(0xFF00F2FF),
                    width: 1.5,
                  ),
                ),
                child: const Text(
                  'RESUME',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            TextButton(
              onPressed: () {
                game.returnToMainMenu();
              },
              child: const Text(
                'MAIN MENU',
                style: TextStyle(
                  color: Color(0xFFBC13FE),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}