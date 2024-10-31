import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/utils/constants.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/entities/snake.dart';
import '../../domain/enums/direction_enum.dart';

enum GameEvent { start, move, restart }

class ChangeDirectionEvent {
  final Direction direction;

  ChangeDirectionEvent(this.direction);
}

class GameBloc extends Bloc<dynamic, GameState> {
  Timer? _timer;

  GameBloc() : super(GameState.initial()) {
    on<GameEvent>((event, emit) {
      if (event == GameEvent.start) {
        _startGame(emit);
      } else if (event == GameEvent.restart) {
        _resetGame(emit);
      } else if (event == GameEvent.move) {
        _moveSnake(emit);
      }
    });

    on<ChangeDirectionEvent>((event, emit) {
      final currentState = state;
      if (!currentState.isGameOver) {
        // Prevent opposite direction change
        if ((event.direction == Direction.up &&
                currentState.snake.direction != Direction.down) ||
            (event.direction == Direction.down &&
                currentState.snake.direction != Direction.up) ||
            (event.direction == Direction.left &&
                currentState.snake.direction != Direction.right) ||
            (event.direction == Direction.right &&
                currentState.snake.direction != Direction.left)) {
          emit(currentState.copyWith(
              snake: currentState.snake.copyWith(direction: event.direction)));
        }
      }
    });
  }

  void _startGame(Emitter<GameState> emit) {
    const tick = Duration(milliseconds: 200);
    _timer?.cancel();
    _timer = Timer.periodic(tick, (timer) {
      add(GameEvent.move);
    });
  }

  void _moveSnake(Emitter<GameState> emit) {
    final currentState = state;
    if (currentState.isGameOver) return;

    // Move the snake
    currentState.snake.move();

    // Check for collisions with walls
    final head = currentState.snake.segments.first;
    if (currentState.walls.contains(head) ||
        head.dx < 0 ||
        head.dx >= AppConstants.gridSize ||
        head.dy < 0 ||
        head.dy >= AppConstants.gridSize ||
        _isSelfCollision(currentState.snake)) {
      emit(currentState.copyWith(isGameOver: true));
      // await _restartGameAfterDelay(emit);
      emit(GameState.initial());
      _startGame(emit);

      return;
    }

    // Check for food collision
    if (head == currentState.food) {
      currentState.snake.grow(); // Implement grow logic
      emit(GameState(
        snake: currentState.snake,
        food: _generateRandomFood(AppConstants.gridSize.toInt()),
        isGameOver: false,
        foodCount: currentState.foodCount + 1,
        walls: currentState.walls,
      ));
    } else {
      emit(GameState(
        snake: Snake(
            segments: List.from(currentState.snake.segments)..removeLast(),
            direction: currentState.snake.direction),
        food: currentState.food,
        isGameOver: false,
        foodCount: currentState.foodCount,
        walls: currentState.walls,
      ));
    }
  }

  bool _isSelfCollision(Snake snake) {
    final head = snake.segments.first;
    return snake.segments
        .skip(1)
        .contains(head); // Check if head collides with the rest of the snake
  }

  // Future<void> _restartGameAfterDelay(Emitter<GameState> emit) async {
  //   await Future.delayed(const Duration(seconds: 2), () {
  //     _resetGame(emit);
  //   });
  // }

  void _resetGame(Emitter<GameState> emit) {
    emit(GameState.initial());
    _startGame(emit);
  }

  Offset _generateRandomFood(int gridSize) {
    Random random = Random();
    return Offset(random.nextInt(gridSize).toDouble(),
        random.nextInt(gridSize).toDouble());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
