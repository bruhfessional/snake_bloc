import 'dart:ui';

import '../../domain/entities/game_state.dart';
import 'dart:math';

class GameRepository {
  GameState getInitialGameState() {
    return GameState(
      snake: [const Offset(5, 5)],
      food: _generateRandomFood(20),
      isGameOver: false,
      direction: Direction.right,
      foodCount: 0,
    );
  }

  Offset _generateRandomFood(int gridSize) {
    Random random = Random();
    return Offset(random.nextInt(gridSize).toDouble(),
        random.nextInt(gridSize).toDouble());
  }
}
