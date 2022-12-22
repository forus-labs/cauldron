import 'package:sugar/core.dart';
import 'package:sugar/src/core/range/range.dart';

import 'package:test/test.dart';

void main() {

  group('Intersects', () {
    group('minMax(...)', () {
      test('overlap', () => expect(Intersects.minMax(const Min.open(5), const Max.open(8)), true));
    });
  });

}
