import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  static const int gridSize = 20;

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
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      add(GameEvent.move);
    });
  }

  void _moveSnake(Emitter<GameState> emit) {
    final currentState = state;
    if (currentState.isGameOver) return;

    currentState.snake.move();

    // Check for collisions
    final head = currentState.snake.segments.first;
    if (head.dx < 0 ||
        head.dx >= gridSize ||
        head.dy < 0 ||
        head.dy >= gridSize) {
      emit(currentState.copyWith(isGameOver: true));
      _restartGameAfterDelay(emit);
      return;
    }

    // Check for food collision
    if (head == currentState.food) {
      currentState.snake.grow();
      emit(GameState(
        snake: currentState.snake,
        food: _generateRandomFood(gridSize),
        isGameOver: false,
        foodCount: currentState.foodCount + 1,
      ));
    } else {
      emit(GameState(
        snake: Snake(
            segments: List.from(currentState.snake.segments)..removeLast(),
            direction: currentState.snake.direction),
        food: currentState.food,
        isGameOver: false,
        foodCount: currentState.foodCount,
      ));
    }
  }

  void _restartGameAfterDelay(Emitter<GameState> emit) {
    Future.delayed(const Duration(seconds: 2), () {
      _resetGame(emit);
    });
  }

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
