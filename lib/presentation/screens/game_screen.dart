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
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

                      if (state.isPaused)
                        TextButton(
                          onPressed: () {
                            context.read<GameBloc>().add(GameEvent.start);
                          },
                          child: const Row(
                            children: [
                              Text(
                                'Paused',
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(Icons.play_arrow)
                            ],
                          ),
                        )
                      else
                        TextButton(
                          onPressed: () {
                            context.read<GameBloc>().add(GameEvent.pause);
                          },
                          child: const Row(
                            children: [
                              Text(
                                'Running',
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(Icons.pause)
                            ],
                          ),
                        )
                    ],
                  ),

                  // Border widget
                  Container(
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
                  const Spacer(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
