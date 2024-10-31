import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake/presentation/widgets/game_painter.dart';

import '../../core/utils/constants.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/enums/direction_enum.dart';
import '../bloc/game_bloc.dart';

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
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: BlocBuilder<GameBloc, GameState>(
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Food counter
                  Text(
                    'Food: ${state.foodCount}',
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Border widget
                  Container(
                    // width: 400,
                    // height: 400,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: CustomPaint(
                      size: const Size(
                          AppConstants.gridSize * AppConstants.gridSize,
                          AppConstants.gridSize * AppConstants.gridSize),
                      painter: GamePainter(
                        state.snake.segments,
                        state.food,
                        state.walls,
                      ), // Pass walls
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
