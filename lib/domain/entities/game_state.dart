import 'dart:math';

import 'package:flutter/material.dart';
import '../enums/direction_enum.dart';
import 'snake.dart';

class GameState {
  final Snake snake;
  final Offset food;
  final bool isGameOver;
  final int foodCount;
  final List<Offset> walls; // List to hold wall positions

  GameState({
    required this.snake,
    required this.food,
    required this.isGameOver,
    required this.foodCount,
    required this.walls,
  });

  static GameState initial() {
    final initialSnake =
        Snake(segments: [const Offset(5, 5)], direction: Direction.right);
    const initialFood = Offset(10, 10);
    return GameState(
        snake: initialSnake,
        food: const Offset(10, 10),
        // Randomize food position
        isGameOver: false,
        foodCount: 0,
        walls: _generateRandomWalls(initialSnake, initialFood));
  }

  // Method to generate random walls
  static List<Offset> _generateRandomWalls(Snake snake, Offset food,
      {int count = 10}) {
    Random random = Random();
    Set<Offset> wallPositions = {};

    while (wallPositions.length < count) {
      double x = random.nextInt(20).toDouble();
      double y = random.nextInt(20).toDouble();
      Offset newWall = Offset(x, y);

      // Ensure the new wall does not overlap with the snake or food
      if (!snake.segments.contains(newWall) && newWall != food) {
        wallPositions.add(newWall);
      }
    }

    return wallPositions.toList();
  }

  GameState copyWith({
    Snake? snake,
    Offset? food,
    bool? isGameOver,
    int? foodCount,
    List<Offset>? walls,
  }) {
    return GameState(
      snake: snake ?? this.snake,
      food: food ?? this.food,
      isGameOver: isGameOver ?? this.isGameOver,
      foodCount: foodCount ?? this.foodCount,
      walls: walls ?? this.walls,
    );
  }
}
