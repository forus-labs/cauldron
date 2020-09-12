import 'package:test/test.dart';

import 'package:sugar/sugar.dart';

String stringify(dynamic value) => value.toString();

int increase(int value) => value + 1;

int decrease(int value) => value - 1;

int zero(int value) => 0;

void main() {
  group('Pair', () {
    final pair = Pair(1, 2);

    test('replace', () => expect(pair.replace(key: 2, value: 3), Pair(2, 3)));

    test('map', () => expect(pair.map(stringify, increase), Pair('1',  3)));

    test('reduce', () => expect(pair.reduce((a, b) => a + b), 3));

    test('fields', () {
      expect(pair.key, 1);
      expect(pair.value, 2);
      expect(pair.fields, [1, 2]);
    });
  });

  group('Triple', () {
    final triple = Triple(1, 2, 3);

    test('replace', () => expect(triple.replace(left: 4, middle: 5, right: 6), Triple(4, 5, 6)));

    test('map', () => expect(triple.map(stringify, decrease, increase), Triple('1', 1, 4)));

    test('reduce', () => expect(triple.reduce((a, b, c) => a + b + c), 6));

    test('fields', () {
      expect(triple.left, 1);
      expect(triple.middle, 2);
      expect(triple.right, 3);
      expect(triple.fields, [1, 2, 3]);
    });
  });

  group('Quad', () {
    final quad = Quad(1, 2, 3, 4);

    test('replace', () => expect(quad.replace(first: 5, second: 6, third: 7, fourth: 8), Quad(5, 6, 7, 8)));

    test('map', () => expect(quad.map(stringify, decrease, increase, zero), Quad('1', 1, 4, 0)));

    test('reduce', () => expect(quad.reduce((a, b, c, d) => a + b + c + d), 10));
  });

  group('TupleIterable', () {
    test('pairs', () => expect([[1, 'a']].pairs<int, String>().toList(), [Pair(1, 'a')]));

    test('pairs throw exception', () {
      expect(() => [[1]].pairs(), throwsArgumentError);
      expect(() => [[1, 2, 3]].pairs(), throwsArgumentError);
    });


    test('triples', () => expect([[1, 'a', 3]].triples<int, String, int>().toList(), [Triple(1, 'a', 3)]));

    test('triples throw exception', () {
      expect(() => [[1, 2]].triples(), throwsArgumentError);
      expect(() => [[1, 2, 3, 4]].triples(), throwsArgumentError);
    });


    test('quads', () => expect([[1, 2, 3, 'a']].quads<int, int, int, String>().toList(), [Quad(1, 2, 3, 'a')]));

    test('quads throw exception', () {
      expect(() => [[1, 2, 3]].pairs(), throwsArgumentError);
      expect(() => [[1, 2, 3, 4, 'a']].pairs(), throwsArgumentError);
    });
  });
}