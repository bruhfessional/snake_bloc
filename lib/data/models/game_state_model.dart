import 'dart:ui';

class GameStateModel {
  final List<Offset> snake;
  final Offset food;
  final bool isGameOver;
  final String direction; // Use String for serialization

  GameStateModel({
    required this.snake,
    required this.food,
    required this.isGameOver,
    required this.direction,
  });
}
