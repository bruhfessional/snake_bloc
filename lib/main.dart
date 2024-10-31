import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui';
import 'game_bloc.dart';

void main() {
  runApp(SnakeGame());
}

class SnakeGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snake Game',
      home: BlocProvider(
        create: (context) => GameBloc(20)..add(GameEvent.start),
        child: GameScreen(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.delta.dy > 0) {
          context.read<GameBloc>().add(ChangeDirectionEvent('down'));
        } else {
          context.read<GameBloc>().add(ChangeDirectionEvent('up'));
        }
      },
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 0) {
          context.read<GameBloc>().add(ChangeDirectionEvent('right'));
        } else {
          context.read<GameBloc>().add(ChangeDirectionEvent('left'));
        }
      },
      child: Scaffold(
        body: BlocBuilder<GameBloc, GameState>(
          builder: (context, state) {
            return CustomPaint(
              painter: GamePainter(state.snake, state.food),
              child: Container(),
            );
          },
        ),
      ),
    );
  }
}

class GamePainter extends CustomPainter {
  final List<Offset> snake;
  final Offset food;

  GamePainter(this.snake, this.food);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.green;
    for (var segment in snake) {
      canvas.drawRect(Rect.fromLTWH(segment.dx * 20, segment.dy * 20, 20, 20), paint);
    }

    paint.color = Colors.red;
    canvas.drawRect(Rect.fromLTWH(food.dx * 20, food.dy * 20, 20, 20), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
