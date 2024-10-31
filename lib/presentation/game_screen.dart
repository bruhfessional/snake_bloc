import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/entities/game_state.dart';
import '../domain/enums/direction_enum.dart';
import 'bloc/game_bloc.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.delta.dy > 0) {
          context.read<GameBloc>().add(ChangeDirectionEvent(Direction.down));
        } else {
          context.read<GameBloc>().add(ChangeDirectionEvent(Direction.up));
        }
      },
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 0) {
          context.read<GameBloc>().add(ChangeDirectionEvent(Direction.right));
        } else {
          context.read<GameBloc>().add(ChangeDirectionEvent(Direction.left));
        }
      },
      child: Scaffold(
        body: Center(
          child: Stack(
            children: [
              // Border widget
              Container(
                width: 420,
                height: 420,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 4),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // Game area
              BlocBuilder<GameBloc, GameState>(
                builder: (context, state) {
                  return CustomPaint(
                    size: const Size(400, 400),
                    painter: GamePainter(
                      state.snake.segments,
                      state.food,
                      state.walls,
                    ), // Pass walls
                  );
                },
              ),
              // Food counter
              Positioned(
                top: 10,
                left: 10,
                child: BlocBuilder<GameBloc, GameState>(
                  builder: (context, state) {
                    return Text(
                      'Food: ${state.foodCount}',
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
          Rect.fromLTWH(segment.dx * 20, segment.dy * 20, 20, 20), paint);
    }

    // Draw food
    paint.color = Colors.red;
    canvas.drawRect(Rect.fromLTWH(food.dx * 20, food.dy * 20, 20, 20), paint);

    // Draw walls
    paint.color = Colors.black; // Color for walls
    for (var wall in walls) {
      canvas.drawRect(Rect.fromLTWH(wall.dx * 20, wall.dy * 20, 20, 20), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
