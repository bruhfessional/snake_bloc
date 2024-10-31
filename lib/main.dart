import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'presentation/bloc/game_bloc.dart';
import 'presentation/screens/game_screen.dart';

void main() {
  runApp(const SnakeGame());
}

class SnakeGame extends StatelessWidget {
  const SnakeGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snake Game',
      home: BlocProvider(
        create: (context) => GameBloc()..add(GameEvent.start),
        child: const GameScreen(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
