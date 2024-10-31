import '../entities/game_state.dart';
import '../enums/direction_enum.dart';

class UpdateGameState {
  final GameState currentState;

  UpdateGameState(this.currentState);

  GameState execute(Direction newDirection) {
    // Implement your game state update logic here.
    return currentState; // Replace with your logic.
  }
}
