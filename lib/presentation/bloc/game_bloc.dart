import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/game_state.dart';
import '../../data/repositories/game_repository.dart';

enum GameEvent { start, move, restart }

class ChangeDirectionEvent {
  final Direction direction;

  ChangeDirectionEvent(this.direction);
}

class GameBloc extends Bloc<dynamic, GameState> {
  final GameRepository gameRepository;

  GameBloc(this.gameRepository)
      : super(gameRepository.getInitialGameState()) {
    on<GameEvent>((event, emit) {
      // Handle game events
    });

    on<ChangeDirectionEvent>((event, emit) {
      // Handle direction change
    });
  }
}
