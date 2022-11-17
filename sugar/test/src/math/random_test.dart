import 'dart:math';

import 'package:sugar/src/math/random.dart';
import 'package:test/test.dart';

void main() {
  group('Randoms', () {
    group('nextBoundedDouble(...)', () {
      test('', () {
        print(Random().nextBoundedDouble(-1, 1));
      });
    });

    group('nextBoundedInt(...)', () {
      test('', () {
          a(FakeRandom());
          // a(Random());
      });
    });
  });
}


void a(Random random) {
  random.nextBoundedInt(0, 1);
}
