import 'dart:ui';

enum Direction { up, down, left, right }

class GameState {
  final List<Offset> snake;
  final Offset food;
  final bool isGameOver;
  final Direction direction;
  final int foodCount;

  GameState({
    required this.snake,
    required this.food,
    required this.isGameOver,
    required this.direction,
    required this.foodCount,
  });
}
