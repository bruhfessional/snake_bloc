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

  GameState({
    required this.snake,
    required this.food,
    required this.isGameOver,
    required this.direction,
  });
}

class GameBloc extends Bloc<dynamic, GameState> {
  final int gridSize;
  Timer? _timer;

  GameBloc(this.gridSize)
      : super(GameState(
    snake: [Offset(5, 5)],
    food: Offset(10, 10),
    isGameOver: false,
    direction: 'right',
  )) {
    on<GameEvent>((event, emit) {
      if (event == GameEvent.start) {
        _startGame();
      } else if (event == GameEvent.restart) {
        emit(GameState(
          snake: [Offset(5, 5)],
          food: _generateFood(),
          isGameOver: false,
          direction: 'right',
        ));
        _startGame();
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

    if (newHead == currentState.food) {
      emit(GameState(
        snake: [newHead, ...currentState.snake],
        food: _generateFood(),
        isGameOver: false,
        direction: currentState.direction,
      ));
    } else {
      final newSnake = [newHead, ...currentState.snake];
      newSnake.removeLast();

      if (_isGameOver(newHead)) {
        emit(GameState(
          snake: newSnake,
          food: currentState.food,
          isGameOver: true,
          direction: currentState.direction,
        ));
      } else {
        emit(GameState(
          snake: newSnake,
          food: currentState.food,
          isGameOver: false,
          direction: currentState.direction,
        ));
      }
    }
  }

  Offset _generateFood() {
    Random random = Random();
    return Offset(random.nextInt(gridSize).toDouble(),
        random.nextInt(gridSize).toDouble());
  }

  bool _isGameOver(Offset head) {
    return head.dx < 0 ||
        head.dx >= gridSize ||
        head.dy < 0 ||
        head.dy >= gridSize ||
        state.snake.skip(1).contains(head);
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
