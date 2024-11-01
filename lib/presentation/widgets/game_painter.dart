import 'package:flutter/material.dart';

import '../../core/utils/constants.dart';

class GamePainter extends CustomPainter {
  final List<Offset> snake;
  final Offset food;
  final List<Offset> walls; // Add walls parameter

  GamePainter(this.snake, this.food, this.walls);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.green;

    // Draw snake
    // for (var segment in snake) {
    for (int i = 0; i < snake.length; i++) {
      canvas.drawRect(
          Rect.fromLTWH(
              snake[i].dx * AppConstants.gridSize,
              snake[i].dy * AppConstants.gridSize,
              AppConstants.gridSize,
              AppConstants.gridSize),
          // paint,
          Paint()..color = Color.fromRGBO(0, 240 - i * 3, 0, 1));
    }

    // Draw food
    paint.color = Colors.red;
    canvas.drawRect(
        Rect.fromLTWH(
            food.dx * AppConstants.gridSize,
            food.dy * AppConstants.gridSize,
            AppConstants.gridSize,
            AppConstants.gridSize),
        paint);

    // Draw walls
    paint.color = Colors.black; // Color for walls
    for (var wall in walls) {
      canvas.drawRect(
          Rect.fromLTWH(
              wall.dx * AppConstants.gridSize,
              wall.dy * AppConstants.gridSize,
              AppConstants.gridSize,
              AppConstants.gridSize),
          paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
