import 'dart:ui';
import '../enums/direction_enum.dart';

class Snake {
  List<Offset> segments;
  Direction direction;

  Snake({
    required this.segments,
    required this.direction,
  });

  void move() {
    const step = 1;
    if (segments.isEmpty) return; // Prevent moving if the snake has no segments

    Offset newHead = segments.first;

    switch (direction) {
      case Direction.up:
        newHead = Offset(newHead.dx, newHead.dy - step);
        break;
      case Direction.down:
        newHead = Offset(newHead.dx, newHead.dy + step);
        break;
      case Direction.left:
        newHead = Offset(newHead.dx - step, newHead.dy);
        break;
      case Direction.right:
        newHead = Offset(newHead.dx + step, newHead.dy);
        break;
    }

    segments.insert(
        0, newHead); // Add the new head to the front of the segments
  }

  void grow() {
    // Logic to grow the snake
    segments.add(segments.last); // Add a new segment at the tail
  }

  Snake copyWith({List<Offset>? segments, Direction? direction}) {
    return Snake(
      segments: segments ?? this.segments,
      direction: direction ?? this.direction,
    );
  }
}
