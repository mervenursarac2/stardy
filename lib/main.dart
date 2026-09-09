import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'state/game_state_provider.dart';
import 'ui/main_menu.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => GameStateProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainMenu(),
      ),
    ),
  );
}