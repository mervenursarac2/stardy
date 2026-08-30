import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'game/stardy_game.dart';
import 'state/game_state_provider.dart';
import 'ui/main_menu.dart';
import 'ui/game_hud.dart';
import 'ui/game_over_overlay.dart';
import 'ui/pause_overlay.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (_) => GameStateProvider(),
      child: const StardyApp(),
    ),
  );
}

class StardyApp extends StatefulWidget {
  const StardyApp({super.key});

  @override
  State<StardyApp> createState() => _StardyAppState();
}

class _StardyAppState extends State<StardyApp> {
  late final StardyGame _game;

  @override
  void initState() {
    super.initState();
    // Provider referansını oyuna iletiyoruz
    _game = StardyGame(gameStateProvider: context.read<GameStateProvider>());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        body: GameWidget<StardyGame>(
          game: _game,
          initialActiveOverlays: const ['MainMenu'],
          overlayBuilderMap: {
            'MainMenu': (context, game) => MainMenu(game: game),
            'GameHud': (context, game) => GameHud(game: game),
            'GameOver': (context, game) => GameOverOverlay(game: game),
            'Pause': (context, game) => PauseOverlay(game: game),
          },
        ),
      ),
    );
  }
}