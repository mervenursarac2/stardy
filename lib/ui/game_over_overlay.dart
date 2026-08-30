import 'package:flutter/material.dart';

import '../game/stardy_game.dart';

class GameOverOverlay extends StatelessWidget {
  final StardyGame game;

  const GameOverOverlay({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xFF11131D).withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFBC13FE),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'GAME OVER',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
            'SCORE',
            style: TextStyle(
                color: Color(0xFF00F2FF),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
            ),
            ),

            const SizedBox(height: 6),

            Text(
            game.score.floor().toString().padLeft(3, '0'),
            style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
            ),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
                game.restartGame();
              },
              child: const Text('PLAY AGAIN'),
            ),

            const SizedBox(height: 12),

            TextButton(
              onPressed: () {
                game.returnToMainMenu();
              },
              child: const Text('MAIN MENU'),
            ),
          ],
        ),
      ),
    );
  }
}