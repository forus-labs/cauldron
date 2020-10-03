import 'package:test/test.dart';

import 'package:sugar/sugar.dart';

void main() {
  const list = [1, 2, 3];

  test('distinct', () => expect([1, 2, 2, 3].distinct(), [1, 2, 3]));

  test('listen', () {
    var sum = 0;

    final iterable = list.listen((val) => sum += val);
    expect(sum, 0);

    // ignore: unused_local_variable
    for (final i in iterable) {}
    expect(sum , 6);
  });

  test('mapWhere', () => expect(list.mapWhere((val) => val.isOdd, (even) => even * 4).toList(), [4, 2, 12]));

  test('indexed', () => expect(Map.fromEntries(list.indexed()), {0: 1, 1: 2, 2: 3}));

  test('none', () {
    expect(list.none((val) => val > 3), true);
    expect(list.none((val) => val.isOdd), false);
  });

  test('toMap', () => expect(list.toMap((val) => val.toString(), (val) => val + 1), {'1': 2, '2': 3, '3': 4}));
}