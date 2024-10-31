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
    for (var segment in snake) {
      canvas.drawRect(
          Rect.fromLTWH(
              segment.dx * AppConstants.gridSize,
              segment.dy * AppConstants.gridSize,
              AppConstants.gridSize,
              AppConstants.gridSize),
          paint);
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
