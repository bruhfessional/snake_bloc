import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/utils/constants.dart';
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
    Snake initialSnake =
        Snake(segments: [const Offset(5, 5)], direction: Direction.right);
    Offset initialFood = const Offset(10, 10);

    return GameState(
      snake: initialSnake,
      food: initialFood,
      isGameOver: false,
      foodCount: 0,
      // walls: _generateMaze(AppConstants.gridSize, AppConstants.gridSize),
      walls: _generateRandomWalls(initialSnake, initialFood),
    );
  }

  // Maze generation method
  static List<Offset> _generateMaze(int width, int height) {
    List<List<bool>> visited =
        List.generate(height, (_) => List.filled(width, false));
    List<Offset> walls = [];

    void visit(int x, int y) {
      visited[y][x] = true;

      // Randomly order directions
      List<Offset> directions = [
        const Offset(2, 0), // Right
        const Offset(-2, 0), // Left
        const Offset(0, 2), // Down
        const Offset(0, -2), // Up
      ]..shuffle();

      for (Offset direction in directions) {
        int newX = x + direction.dx.toInt();
        int newY = y + direction.dy.toInt();

        // Check if the new position is within bounds and not visited
        if (newX > 0 &&
            newX < width &&
            newY > 0 &&
            newY < height &&
            !visited[newY][newX]) {
          // Create a wall between the current position and the new position
          walls.add(Offset((x + newX) / 2, (y + newY) / 2));
          visit(newX, newY);
        }
      }
    }

    // Start maze generation from a random position
    visit(Random().nextInt(width ~/ 2) * 2 + 1,
        Random().nextInt(height ~/ 2) * 2 + 1);

    // Convert wall coordinates to the list of offsets
    return walls;
  }

  static List<Offset> _generateRandomWalls(Snake snake, Offset food,
      {int count = 20}) {
    Random random = Random();
    Set<Offset> wallPositions = {};

    while (wallPositions.length < count) {
      // TODO: fix this dumb thing
      double x = random.nextInt(AppConstants.gridSize.toInt()).toDouble();
      double y = random.nextInt(AppConstants.gridSize.toInt()).toDouble();
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
