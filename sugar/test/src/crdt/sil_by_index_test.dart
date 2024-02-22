import 'package:sugar/sugar.dart';
import 'package:test/test.dart';

void main() {
  group('indexOf(...)', () {
    test('default equality', () {
      final sil = Sil.list(['A', 'B', 'C']);

      expect(sil.byIndex.indexOf('F'), -1);
      expect(sil.byIndex.indexOf('A'), 0);
      expect(sil.byIndex.indexOf('B'), 1);
      expect(sil.byIndex.indexOf('C'), 2);
    });

    test('custom equality', () {
      final sil = Sil.list(['A', 'BB', 'CC'], equals: (a, b) => a.length == b.length, hash: (e) => 1).byIndex;

      expect(sil.indexOf('A'), 0);
      expect(sil.indexOf('B'), 0);
      expect(sil.indexOf('CC'), 1);
      expect(sil.indexOf('DD'), 1);
    });
  });

  group('indexWhere(...)', () {
    test('start from 0', () {
      final sil = Sil.list(['A', 'BB', 'C']).byIndex;
      expect(sil.indexWhere((e) => e.length == 1), 0);
    });

    test('start from 1', () {
      final sil = Sil.list(['A', 'BB', 'C']).byIndex;
      expect(sil.indexWhere((e) => e.length == 1, 1), 2);
    });

    test('not found', () {
      final sil = Sil.list(['A', 'BB', 'C']).byIndex;
      expect(sil.indexWhere((e) => false), -1);
    });

    test('empty', () {
      final sil = Sil().byIndex;
      expect(sil.indexWhere((e) => true), -1);
    });
  });

  group('lastIndexWhere(...)', () {
    test('end at last', () {
      final sil = Sil.list(['A', 'BB', 'C']).byIndex;
      expect(sil.lastIndexWhere((e) => e.length == 1), 2);
    });

    test('end at 1', () {
      final sil = Sil.list(['A', 'BB', 'C']).byIndex;
      expect(sil.lastIndexWhere((e) => e.length == 1, 1), 0);
    });

    test('not found', () {
      final sil = Sil.list(['A', 'BB', 'C']).byIndex;
      expect(sil.lastIndexWhere((e) => false), -1);
    });

    test('empty', () {
      final sil = Sil().byIndex;
      expect(sil.lastIndexWhere((e) => true), -1);
    });
  });

  group('insertAll(...)', () {
    test('insert at start', () {
      final sil = Sil.list(['A', 'B', 'C']);
      sil.byIndex.insertAll(0, ['D', 'E']);

      expect(sil.toList(), ['D', 'E', 'A', 'B', 'C']);

      expect(sil.byStringIndex[sil.byStringIndex.indexOf('D')], 'D');
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('E')], 'E');
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('A')], 'A');

      expect(sil.byStringIndex.indexOf('D')! < sil.byStringIndex.indexOf('E')!, true);
      expect(sil.byStringIndex.indexOf('E')! < sil.byStringIndex.indexOf('A')!, true);
    });

    test('insert in middle', () {
      final sil = Sil.list(['A', 'B', 'C']);
      sil.byIndex.insertAll(1, ['D', 'E']);

      expect(sil.toList(), ['A', 'D', 'E', 'B', 'C']);

      expect(sil.byStringIndex[sil.byStringIndex.indexOf('A')], 'A');
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('D')], 'D');
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('E')], 'E');

      expect(sil.byStringIndex.indexOf('A')! < sil.byStringIndex.indexOf('D')!, true);
      expect(sil.byStringIndex.indexOf('D')! < sil.byStringIndex.indexOf('E')!, true);
    });

    test('insert at end', () {
      final sil = Sil.list(['A', 'B', 'C']);
      sil.byIndex.insertAll(3, ['D', 'E']);

      expect(sil.toList(), ['A', 'B', 'C', 'D', 'E']);

      expect(sil.byStringIndex[sil.byStringIndex.indexOf('C')], 'C');
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('D')], 'D');
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('E')], 'E');

      expect(sil.byStringIndex.indexOf('C')! < sil.byStringIndex.indexOf('D')!, true);
      expect(sil.byStringIndex.indexOf('D')! < sil.byStringIndex.indexOf('E')!, true);
    });


    test('duplicates in sil', () {
      final sil = Sil.list(['A']);
      sil.byIndex.insertAll(1, ['A', 'B']);

      expect(sil.toList(), ['A', 'B']);

      expect(sil.byStringIndex[sil.byStringIndex.indexOf('A')], 'A');
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('B')], 'B');

      expect(sil.byStringIndex.indexOf('A')! < sil.byStringIndex.indexOf('B')!, true);
      expect(sil.length, 2);
    });

    test('duplicates in list', () {
      final sil = Sil.list(['A']);
      sil.byIndex.insertAll(1, ['B', 'B']);

      expect(sil.toList(), ['A', 'B']);

      expect(sil.byStringIndex[sil.byStringIndex.indexOf('A')], 'A');
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('B')], 'B');

      expect(sil.byStringIndex.indexOf('A')! < sil.byStringIndex.indexOf('B')!, true);
      expect(sil.length, 2);
    });


    test('custom equality', () {
      final sil = Sil.list(['A'], equals: (a, b) => a.length == b.length, hash: (e) => 1);
      sil.byIndex.insertAll(1, ['BB', 'CC']);

      expect(sil.toList(), ['A', 'BB']);

      expect(sil.byStringIndex[sil.byStringIndex.indexOf('A')], 'A');
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('BB')], 'BB');
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('CC')], 'BB');

      expect(sil.byStringIndex.indexOf('A')! < sil.byStringIndex.indexOf('BB')!, true);
    });


    test('empty', () {
      final sil = Sil();
      sil.byIndex.insertAll(0, ['D', 'E']);

      expect(sil.toList(), ['D', 'E']);

      expect(sil.byStringIndex[sil.byStringIndex.indexOf('D')], 'D');
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('E')], 'E');

      expect(sil.byStringIndex.indexOf('D')! < sil.byStringIndex.indexOf('E')!, true);
    });

    test('negative index', () {
      final sil = Sil.list(['A', 'B', 'C']).byIndex;
      expect(() => sil.insertAll(-1, ['D']), throwsRangeError);
    });

    test('index too large', () {
      final sil = Sil.list(['A', 'B', 'C']).byIndex;
      expect(() => sil.insertAll(4, ['D']), throwsRangeError);
    });
  });

  group('insert(...)', () {
    test('insert at start', () {
      final sil = Sil.list(['A', 'B', 'C']);
      expect(sil.byIndex.insert(0, 'D'), true);

      expect(sil.toList(), ['D', 'A', 'B', 'C']);

      expect(sil.byStringIndex[sil.byStringIndex.indexOf('D')], 'D');
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('A')], 'A');

      expect(sil.byStringIndex.indexOf('D')! < sil.byStringIndex.indexOf('A')!, true);
    });

    test('insert in middle', () {
      final sil = Sil.list(['A', 'B', 'C']);
      expect(sil.byIndex.insert(1, 'D'), true);

      expect(sil.toList(), ['A', 'D', 'B', 'C']);

      expect(sil.byStringIndex[sil.byStringIndex.indexOf('A')], 'A');
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('D')], 'D');

      expect(sil.byStringIndex.indexOf('A')! < sil.byStringIndex.indexOf('D')!, true);
    });

    test('insert at end', () {
      final sil = Sil.list(['A', 'B', 'C']);
      expect(sil.byIndex.insert(3, 'D'), true);

      expect(sil.toList(), ['A', 'B', 'C', 'D']);

      expect(sil.byStringIndex[sil.byStringIndex.indexOf('C')], 'C');
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('D')], 'D');

      expect(sil.byStringIndex.indexOf('C')! < sil.byStringIndex.indexOf('D')!, true);
    });


    test('duplicates', () {
      final sil = Sil.list(['A']);
      final before = sil.byStringIndex.indexOf('A');

      expect(sil.byIndex.insert(1, 'A'), false);
      final after = sil.byStringIndex.indexOf('A');

      expect(sil.toList(), ['A']);

      expect(sil.byStringIndex[sil.byStringIndex.indexOf('A')], 'A');

      expect(before, after);
      expect(sil.length, 1);
    });


    test('custom equality', () {
      final sil = Sil.list(['A'], equals: (a, b) => a.length == b.length, hash: (e) => 1);
      expect(sil.byIndex.insert(1, 'BB'), true);
      expect(sil.byIndex.insert(1, 'C'), false);

      expect(sil.toList(), ['A', 'BB']);

      expect(sil.byStringIndex[sil.byStringIndex.indexOf('A')], 'A');
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('C')], 'A');
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('BB')], 'BB');
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('CC')], 'BB');

      expect(sil.byStringIndex.indexOf('A')! < sil.byStringIndex.indexOf('BB')!, true);
    });


    test('empty', () {
      final sil = Sil();
      expect(sil.byIndex.insert(0, 'D'), true);

      expect(sil.toList(), ['D']);
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('D')], 'D');
      expect(sil.length, 1);
    });

    test('negative index', () {
      final sil = Sil.list(['A', 'B', 'C']).byIndex;
      expect(() => sil.insert(-1, 'D'), throwsRangeError);
    });

    test('index too large', () {
      final sil = Sil.list(['A', 'B', 'C']).byIndex;
      expect(() => sil.insert(4, 'D'), throwsRangeError);
    });
  });

  group('removeAt(...)', () {
    test('remove at start', () {
      final sil = Sil.list(['A', 'B', 'C']);
      expect(sil.byIndex.removeAt(0), 'A');

      expect(sil.toList(), ['B', 'C']);
      expect(sil.byStringIndex.indexOf('A'), null);
      expect(sil.length, 2);
    });

    test('remove in middle', () {
      final sil = Sil.list(['A', 'B', 'C']);
      expect(sil.byIndex.removeAt(1), 'B');

      expect(sil.toList(), ['A', 'C']);
      expect(sil.byStringIndex.indexOf('B'), null);
      expect(sil.length, 2);
    });

    test('remove at end', () {
      final sil = Sil.list(['A', 'B', 'C']);
      expect(sil.byIndex.removeAt(2), 'C');

      expect(sil.toList(), ['A', 'B']);
      expect(sil.byStringIndex.indexOf('C'), null);
      expect(sil.length, 2);
    });

    test('empty', () {
      final sil = Sil();
      expect(() => sil.byIndex.removeAt(0), throwsRangeError);
    });

    test('negative index', () {
      final sil = Sil.list(['A', 'B', 'C']).byIndex;
      expect(() => sil.removeAt(-1), throwsRangeError);
    });

    test('index too large', () {
      final sil = Sil.list(['A', 'B', 'C']).byIndex;
      expect(() => sil.removeAt(3), throwsRangeError);
    });
  });

  group('[]', () {
    test('at start', () {
      final sil = Sil.list(['A', 'B', 'C']);
      expect(sil.byIndex[0], 'A');
    });

    test('in middle', () {
      final sil = Sil.list(['A', 'B', 'C']);
      expect(sil.byIndex[1], 'B');
    });

    test('at end', () {
      final sil = Sil.list(['A', 'B', 'C']);
      expect(sil.byIndex[2], 'C');
    });

    test('empty', () {
      final sil = Sil();
      expect(() => sil.byIndex[0], throwsRangeError);
    });

    test('negative index', () {
      final sil = Sil.list(['A', 'B', 'C']).byIndex;
      expect(() => sil[-1], throwsRangeError);
    });

    test('index too large', () {
      final sil = Sil.list(['A', 'B', 'C']).byIndex;
      expect(() => sil[3], throwsRangeError);
    });
  });

  group('[]=', () {
    test('at start', () {
      final sil = Sil.list(['A', 'B', 'C']);
      sil.byIndex[0] = 'D';

      expect(sil.toList(), ['D', 'B', 'C']);
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('D')], 'D');
      expect(sil.byStringIndex.indexOf('A'), null);
      expect(sil.length, 3);
    });

    test('in middle', () {
      final sil = Sil.list(['A', 'B', 'C']);
      sil.byIndex[1] = 'D';

      expect(sil.toList(), ['A', 'D', 'C']);
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('D')], 'D');
      expect(sil.byStringIndex.indexOf('B'), null);
      expect(sil.length, 3);
    });

    test('at end', () {
      final sil = Sil.list(['A', 'B', 'C']);
      sil.byIndex[2] = 'D';

      expect(sil.toList(), ['A', 'B', 'D']);
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('D')], 'D');
      expect(sil.byStringIndex.indexOf('C'), null);
      expect(sil.length, 3);
    });

    test('empty', () {
      final sil = Sil();
      expect(() => sil.byIndex[0] = 'D', throwsRangeError);
    });

    test('negative index', () {
      final sil = Sil.list(['A', 'B', 'C']).byIndex;
      expect(() => sil[-1] = 'D', throwsRangeError);
    });

    test('index too large', () {
      final sil = Sil.list(['A', 'B', 'C']).byIndex;
      expect(() => sil[3] = 'D', throwsRangeError);
    });
  });
}
