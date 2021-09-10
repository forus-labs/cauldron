import 'dart:collection';
import 'dart:typed_data';

import 'package:sugar/sugar.dart';
import 'package:test/test.dart';

void main() {
  const list = [1, 2, 3];
  const map = {1: 2, 3: 4, 5: 6};
  const set = {1, 2, 3};

  group('ListEquality', () {
    for (final arguments in [[list, true], [[1, 2, 3], true], [Int64List.fromList(list), true], [[1, 2], false], [[1, 2, 4], false]].pairs<List<int>, bool>()) {
      test('equals ${arguments.key}', () => expect(list.equals(arguments.key), arguments.value));
    }
  });

  group('MapEquality', () {
    for (final arguments in [[map, true], [{1: 2, 3: 4, 5: 6}, true], [HashMap.of({1: 2, 3: 4, 5: 6}), true], [{1: 2}, false], [{1: 2, 3: 3, 5: 6}, false]].pairs<Map<int, int>, bool>()) {
      test('equals ${arguments.key}', () => expect(map.equals(arguments.key), arguments.value));
    }
  });

  group('SetEquality', () {
    for (final arguments in [[set, true], [{1, 2, 3}, true], [HashSet.of([1, 2, 3]), true], [{1, 2}, false], [{1, 2, 4}, false]].pairs<Set<int>, bool>()) {
      test('equals ${arguments.key}', () => expect(set.equals(arguments.key), arguments.value));
    }
  });
}