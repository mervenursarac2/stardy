import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game/stardy_game.dart';
import 'ui/main_menu.dart';
import 'ui/game_hud.dart';
import 'ui/game_over_overlay.dart';
import 'ui/pause_overlay.dart';

void main() {
  final game = StardyGame();

  runApp(
    GameWidget(
      game: game,
      initialActiveOverlays: const ['MainMenu'],
      overlayBuilderMap: {
        'MainMenu': (context, game) {
          return MainMenu(game: game as StardyGame);
        },

        'GameHud': (context, game) {
          return GameHud(game: game as StardyGame);
        },

        'GameOver': (context, game) {
          return GameOverOverlay(game: game as StardyGame);
        },
        'Pause': (context, game) {
          return PauseOverlay(game: game as StardyGame);
  },
      },
    ),
  );
}