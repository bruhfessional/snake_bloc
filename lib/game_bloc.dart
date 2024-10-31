import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

enum GameEvent { start, move, restart }

class ChangeDirectionEvent {
  final String direction;

  ChangeDirectionEvent(this.direction);
}

class GameState {
  final List<Offset> snake;
  final Offset food;
  final bool isGameOver;
  final String direction;
  final int foodCount; // Add food count

  GameState({
    required this.snake,
    required this.food,
    required this.isGameOver,
    required this.direction,
    required this.foodCount, // Initialize food count
  });
}

class GameBloc extends Bloc<dynamic, GameState> {
  final int gridSize;
  Timer? _timer;

  GameBloc(this.gridSize)
      : super(GameState(
    snake: [Offset(5, 5)],
    food: _generateRandomFood(gridSize),
    isGameOver: false,
    direction: 'right',
    foodCount: 0, // Initialize food count
  )) {
    on<GameEvent>((event, emit) {
      if (event == GameEvent.start) {
        _startGame();
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
        if ((event.direction == 'up' && currentState.direction != 'down') ||
            (event.direction == 'down' && currentState.direction != 'up') ||
            (event.direction == 'left' && currentState.direction != 'right') ||
            (event.direction == 'right' && currentState.direction != 'left')) {
          emit(GameState(
            snake: currentState.snake,
            food: currentState.food,
            isGameOver: currentState.isGameOver,
            direction: event.direction,
            foodCount: currentState.foodCount, // Preserve food count
          ));
        }
      }
    });
  }

  void _startGame() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: 200), (timer) {
      add(GameEvent.move);
    });
  }

  void _moveSnake(Emitter<GameState> emit) {
    final currentState = state;
    if (currentState.isGameOver) return;

    Offset newHead = currentState.snake.first;

    switch (currentState.direction) {
      case 'up':
        newHead = Offset(newHead.dx, newHead.dy - 1);
        break;
      case 'down':
        newHead = Offset(newHead.dx, newHead.dy + 1);
        break;
      case 'left':
        newHead = Offset(newHead.dx - 1, newHead.dy);
        break;
      case 'right':
        newHead = Offset(newHead.dx + 1, newHead.dy);
        break;
    }

    // Check for collisions with the walls
    if (newHead.dx < 0 || newHead.dx >= gridSize || newHead.dy < 0 || newHead.dy >= gridSize) {
      print("Game Over: Collided with wall");
      _resetGame(emit);
      return;
    }

    // Check for food collision
    if (newHead == currentState.food) {
      emit(GameState(
        snake: [newHead, ...currentState.snake],
        food: _generateRandomFood(gridSize),
        isGameOver: false,
        direction: currentState.direction,
        foodCount: currentState.foodCount + 1, // Increment food count
      ));
    } else {
      // Move snake
      final newSnake = [newHead, ...currentState.snake];
      newSnake.removeLast();

      // Check for self-collision
      if (_isGameOver(newHead, newSnake)) {
        print("Game Over: Collided with itself");
        _resetGame(emit);
      } else {
        emit(GameState(
          snake: newSnake,
          food: currentState.food,
          isGameOver: false,
          direction: currentState.direction,
          foodCount: currentState.foodCount, // Preserve food count
        ));
      }
    }
  }

  void _resetGame(Emitter<GameState> emit) {
    emit(GameState(
      snake: [Offset(5, 5)],
      food: _generateRandomFood(gridSize),
      isGameOver: false,
      direction: 'right',
      foodCount: 0, // Reset food count
    ));
    _startGame();
  }

  static Offset _generateRandomFood(int gridSize) {
    Random random = Random();
    return Offset(random.nextInt(gridSize).toDouble(),
        random.nextInt(gridSize).toDouble());
  }

  bool _isGameOver(Offset head, List<Offset> snake) {
    return snake.skip(1).contains(head);
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
