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
    return GameState(
      snake: Snake(segments: [Offset(5, 5)], direction: Direction.right),
      food: const Offset(10, 10),
      // Randomize food position
      isGameOver: false,
      foodCount: 0,
      walls: _generateRandomWalls(), // Generate walls at initialization
    );
  }

  // Method to generate random walls
  static List<Offset> _generateRandomWalls({int count = 10}) {
    Random random = Random();
    Set<Offset> wallPositions = {};

    while (wallPositions.length < count) {
      double x = random.nextInt(20).toDouble(); // Assuming grid size is 20
      double y = random.nextInt(20).toDouble();
      wallPositions.add(Offset(x, y));
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
