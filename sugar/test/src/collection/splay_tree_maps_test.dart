import 'dart:collection';

import 'package:sugar/sugar.dart';
import 'package:test/test.dart';

void main() {
  group('SplayTreeMaps', () {
    final map = SplayTreeMap.of({1: 'A', 2: 'B', 3: 'C'});

    group('firstValueAfter(...)', () {
      test('key exists', () => expect(map.firstValueAfter(1), 'B'));

      test('key does not exist', () => expect(map.firstValueAfter(3), null));
    });

    group('lastValueBefore(...)', () {
      test('key exists', () => expect(map.lastValueBefore(3), 'B'));

      test('key does not exist', () => expect(map.lastValueBefore(1), null));
    });
  });
}
