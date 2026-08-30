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
    GameWidget<StardyGame>(
      game: game,
      initialActiveOverlays: const ['MainMenu'],
      overlayBuilderMap: {
        'MainMenu': (BuildContext context, StardyGame game) {
          return MainMenu(game: game);
        },
        'GameHud': (BuildContext context, StardyGame game) {
          return GameHud(game: game);
        },
        'GameOver': (BuildContext context, StardyGame game) {
          return GameOverOverlay(game: game);
        },
        'Pause': (BuildContext context, StardyGame game) {
          return PauseOverlay(game: game);
        },
      },
    ),
  );
}