import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game/stardy_game.dart';

void main() {
  runApp(
    GameWidget(
      game: StardyGame(),
    ),
  );
}