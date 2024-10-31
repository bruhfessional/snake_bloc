import 'dart:ui';

import 'package:snake/domain/entities/snake.dart';

import '../enums/direction_enum.dart';

class GameState {
  final Snake snake;
  final Offset food;
  final bool isGameOver;
  final int foodCount;

  GameState({
    required this.snake,
    required this.food,
    required this.isGameOver,
    required this.foodCount,
  });

  static GameState initial() {
    return GameState(
      snake: Snake(segments: [const Offset(5, 5)], direction: Direction.right),
      food: const Offset(10, 10), // Randomize this as needed
      isGameOver: false,
      foodCount: 0,
    );
  }

  GameState copyWith({
    Snake? snake,
    Offset? food,
    bool? isGameOver,
    int? foodCount,
  }) {
    return GameState(
      snake: snake ?? this.snake,
      food: food ?? this.food,
      isGameOver: isGameOver ?? this.isGameOver,
      foodCount: foodCount ?? this.foodCount,
    );
  }
}
