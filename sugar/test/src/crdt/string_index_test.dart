import 'dart:math';

import 'package:sugar/sugar.dart';
import 'package:test/test.dart';

final _random = Random();
final _index = StringBuffer();

Iterable<(String, String)> get boundaries sync* {
  const iterations = 2000; // Tweak this to adjust the number of tests
  for (var i = 0; i < iterations; i++) {
    var min = generate();
    var max = generate();
    while (min.isEmpty || max.isEmpty || min >= max) {
      min = generate();
      max = generate();
    }

    yield (min, max);
  }
}

String generate() {
  final length = _random.nextInt(8) + 1;
  for (var i = 0; i < length; i++) {
    _index.writeCharCode(StringIndex.ascii[_random.nextInt(StringIndex.ascii.length)]);
  }

  final index =  _index.toString().replaceAll(RegExp(r'(\+)+$'), '');
  _index.clear();

  return index;
}


void main() {

  group('validation', () {
    for (final (min, max) in [
      ('b', 'a'),
      ('a', 'a'),
      ('a++++', 'a++'),
      ('a++', 'a+++++++'),
      ('a', 'a++++'),
      ('a++++++', 'a'),
    ]) {
      test('start index >= end index', () => expect(
        () => StringIndex.between(min: min, max: max),
        throwsA(predicate<ArgumentError>(
          (e) => e.message == 'Invalid range: $min - $max, minimum should be less than maximum.'
        )),
      ));
    }

    for (final argument in ['1241=', '20"385r2', '漢字']) {
      test('invalid min format', () => expect(
        () => StringIndex.between(min: argument),
        throwsA(predicate<ArgumentError>(
          (e) => e.message == 'Invalid minimum string index: $argument, should follow the format: ${StringIndex.format.pattern}.'
        )),
      ));

      test('invalid max format', () => expect(
        () => StringIndex.between(max: argument),
        throwsA(predicate<ArgumentError>(
          (e) => e.message == 'Invalid maximum string index: $argument, should follow the format: ${StringIndex.format.pattern}.'
        )),
      ));
    }
  });

  test('wrap around', () {
    final value = StringIndex.between(min: '+yzz', max: '-');
    expect(value > '+yzz', true);
    expect(value < '-', true);
  });

  test('boundary', () {
    final value = StringIndex.between(min: '+zzz', max: '-');
    expect(value.compareTo('+zzz'), 1);
    expect(value.compareTo('/'), -1);
  });

  for (final (min, max) in boundaries) {
    test('property test: insert between $min and $max', () {
      final value = StringIndex.between(min: min, max: max);
      expect(value.endsWith('+'), false);
      expect(value.compareTo(min), 1, reason: '$value <= $min');
      expect(value.compareTo(max), -1, reason: '$value >= $max');
    }, tags: ['property']);
  }
}
