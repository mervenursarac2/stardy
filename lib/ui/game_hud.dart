import 'package:flutter/material.dart';

import '../game/stardy_game.dart';

class GameHud extends StatelessWidget {
  final StardyGame game;

  const GameHud({
    super.key,
    required this.game,
  });

  static const Color cyan = Color(0xFF00F2FF);
  static const Color purple = Color(0xFFBC13FE);
  static const Color white = Color(0xFFE8F7FF);
  static const Color dark = Color(0xFF101521);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: false,
      child: Stack(
        children: [
          // =========================================
          // TOP LEFT - SCORE
          // =========================================

          Positioned(
            top: 18,
            left: 18,
            child: _ScorePanel(
              score: game.score,
            ),
          ),

          // =========================================
          // MULTIPLIER
          // =========================================

          Positioned(
            top: 28,
            left: 100,
            child: _MultiplierBadge(),
          ),

          // =========================================
          // PAUSE BUTTON
          // =========================================

          Positioned(
            top: 18,
            right: 18,
            child: GestureDetector(
            onTap: () {
                game.togglePause();
            },
            child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF101521).withOpacity(0.85),
                border: Border.all(
                    color: const Color(0xFF00F2FF),
                    width: 1.5,
                ),
                boxShadow: [
                    BoxShadow(
                    color: const Color(0xFF00F2FF).withOpacity(0.35),
                    blurRadius: 15,
                    ),
                ],
                ),
                child: const Icon(
                Icons.pause,
                color: Colors.white,
                size: 24,
                ),
            ),
            ),
          ),

          // =========================================
          // PLASMA CORE
          // =========================================

          Positioned(
            left: 28,
            right: 28,
            bottom: 20,
            child: _PlasmaBar(
              percentage: game.plasmaPercent,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================================================
// SCORE PANEL
// ==================================================

class _ScorePanel extends StatelessWidget {
  final int score;

  const _ScorePanel({
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 135,
      height: 68,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF111721).withOpacity(0.88),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
        ),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00F2FF).withOpacity(0.08),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DISTANCE',
            style: TextStyle(
              color: Color(0xFF8A9BAA),
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.4,
            ),
          ),

          const SizedBox(height: 1),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatScore(score),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),

              const SizedBox(width: 4),

              const Padding(
                padding: EdgeInsets.only(bottom: 2),
                child: Text(
                  'LV',
                  style: TextStyle(
                    color: Color(0xFF82919C),
                    fontSize: 8,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatScore(int score) {
    return score
        .toString()
        .padLeft(3, '0');
  }
}

// ==================================================
// MULTIPLIER
// ==================================================

class _MultiplierBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF091820).withOpacity(0.9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF00F2FF),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00F2FF).withOpacity(0.25),
            blurRadius: 10,
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.bolt,
            color: Color(0xFF00F2FF),
            size: 12,
          ),
          SizedBox(width: 3),
          Text(
            'MULTIPLIER ×2',
            style: TextStyle(
              color: Color(0xFF00F2FF),
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================================================
// PLASMA BAR
// ==================================================

class _PlasmaBar extends StatelessWidget {
  final double percentage;

  const _PlasmaBar({
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'PLASMA CORE',
              style: TextStyle(
                color: Color(0xFFC8C9D7),
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),

            Text(
              '${(percentage * 100).round()}%',
              style: const TextStyle(
                color: Color(0xFFE8C7FF),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 5),

        Container(
          height: 8,
          decoration: BoxDecoration(
            color: const Color(0xFF202433),
            borderRadius: BorderRadius.circular(5),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF00F2FF),
                    Color(0xFFBC13FE),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF00F2FF),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}