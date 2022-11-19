import 'package:sugar/collection.dart';

import 'package:test/test.dart';

void main() {

  group('by(...)', () {
    test('multiple unique values', () => expect(
      ['a', 'aa', 'b', 'bb', 'cc'].group.by<dynamic, int>((e) => e.length, as: (count, e) => (count ?? 0) + 1),
      {1: 2, 2: 3},
    ));

    test('multiple duplicate values', () => expect(
      ['a', 'b', 'aa', 'b', 'bb', 'cc', 'cc'].group.by<dynamic, int>((e) => e.length, as: (count, e) => (count ?? 0) + 1),
      {1: 3, 2: 4},
    ));

    test('empty', () => expect([].group.by<dynamic, int>((e) => e, as: (count, e) => (count ?? 0) + 1), {}));
  });

  group('lists(...)', () {
    test('multiple unique values', () => expect(
      ['a', 'aa', 'b', 'bb', 'cc'].group.lists(by: (e) => e.length),
      {1: ['a', 'b'], 2: ['aa', 'bb', 'cc']},
    ));

    test('multiple duplicate values', () => expect(
      ['a', 'b', 'aa', 'b', 'bb', 'cc', 'cc'].group.lists(by: (e) => e.length),
      {1: ['a', 'b', 'b'], 2: ['aa', 'bb', 'cc', 'cc']},
    ));
    
    test('empty', () => expect([].group.lists(by: (e) => e), {}));
  });

  group('sets(...)', () {
    test('multiple unique values', () => expect(
      ['a', 'b', 'aa', 'bb', 'cc'].group.sets(by: (e) => e.length),
      {1: {'a', 'b'}, 2: {'aa', 'bb', 'cc'}},
    ));

    test('multiple duplicate values', () => expect(
      ['a', 'b', 'aa', 'b', 'bb', 'cc', 'cc'].group.sets(by: (e) => e.length),
      {1: {'a', 'b'}, 2: {'aa', 'bb', 'cc'}},
    ));

    test('empty', () => expect([].group.sets(by: (e) => e), {}));
  });

}
