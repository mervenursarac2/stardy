import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game/stardy_game.dart';
import '../state/game_state_provider.dart';
import '../tetris/tetris_screen.dart';
import 'game_hud.dart';
import 'game_over_overlay.dart';
import 'pause_overlay.dart';

class ArcadeHub extends StatelessWidget {
  const ArcadeHub({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0D17),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF00F2FF), size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 12),
              const Text(
                'STARDY ARCADE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'SELECT MISSION PROTOCOL',
                style: TextStyle(
                  color: Color(0xFF00F2FF),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 28),

              // 1. Oyun: Space Runner (Tıklandığı an oyun başlar)
              _GameCard(
                title: 'SPACE RUNNER',
                subtitle: 'Dodge meteors & navigate deep void',
                icon: Icons.rocket_launch_rounded,
                accentColor: const Color(0xFFBC13FE),
                onTap: () {
                  final game = StardyGame(gameStateProvider: context.read<GameStateProvider>());
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Scaffold(
                        body: GameWidget<StardyGame>(
                          game: game,
                          // Ara menü atlanır, doğrudan HUD gelir:
                          initialActiveOverlays: const ['GameHud'],
                          overlayBuilderMap: {
                            'GameHud': (ctx, g) => GameHud(game: g),
                            'GameOver': (ctx, g) => GameOverOverlay(game: g),
                            'Pause': (ctx, g) => PauseOverlay(game: g),
                          },
                        ),
                      ),
                    ),
                  );
                  // Flame döngüsünü gecikmesiz doğrudan başlatır
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    game.startGame();
                  });
                },
              ),

              const SizedBox(height: 18),

              // 2. Oyun: Cosmic Tetris (Tıklandığı an başlar)
              _GameCard(
                title: 'COSMIC TETRIS',
                subtitle: 'Align galactic matrix fragments',
                icon: Icons.grid_view_rounded,
                accentColor: const Color(0xFF00F2FF),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TetrisScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;

  const _GameCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF131524),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: accentColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.2),
              blurRadius: 12,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accentColor, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF8E92A8),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: accentColor, size: 16),
          ],
        ),
      ),
    );
  }
}