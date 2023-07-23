import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stevia/src/widgets/resizable/box/direction.dart';

void main() {

  for (final (direction, alignment) in [
    (Direction.left, Alignment.centerLeft),
    (Direction.top, Alignment.topCenter),
    (Direction.right, Alignment.centerRight),
    (Direction.bottom, Alignment.bottomCenter),
  ]) {
    test('alignment', () => expect(direction.alignment, alignment));
  }

  for (final (direction, opposite) in [
    (Direction.left, Direction.right),
    (Direction.top, Direction.bottom),
    (Direction.right, Direction.left),
    (Direction.bottom, Direction.top),
  ]) {
    test('flip()', () => expect(direction.flip(), opposite));
  }

}
