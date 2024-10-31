import '../../domain/entities/game_state.dart';
import '../../domain/entities/snake.dart';
import 'dart:math';
import 'package:flutter/material.dart';

import '../../domain/enums/direction_enum.dart';

class GameRepository {
  static Offset generateRandomFood(int gridSize) {
    Random random = Random();
    return Offset(random.nextInt(gridSize).toDouble(),
        random.nextInt(gridSize).toDouble());
  }
}
