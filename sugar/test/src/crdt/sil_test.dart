import 'package:sugar/sugar.dart';
import 'package:test/test.dart';

void main() {
  group('Sil.map(...)', () {
    test('default equality and hash code', () {
      final sil = Sil.map({StringIndex('a'): 'A', StringIndex('d'): 'B', StringIndex('b'): 'B'});
      expect(sil.toList(), ['A', 'B']);

      expect(sil.byStringIndex['a'], 'A');
      expect(sil.byStringIndex['b'], 'B');

      expect(sil.byStringIndex.indexOf('A'), 'a');
      expect(sil.byStringIndex.indexOf('B'), 'b');

      expect(sil.byStringIndex.indexed.toList(), [(StringIndex('a'), 'A'), (StringIndex('b'), 'B')]);
    });

    test('custom equality and hash code', () {
      final sil = Sil.map(
        {StringIndex('a'): 'A', StringIndex('d'): 'BD', StringIndex('b'): 'BB'},
        equals: (a, b) => a.length == b.length,
        hash: (e) => 1,
      );

      expect(sil.toList(), ['A', 'BB']);

      expect(sil.byStringIndex['a'], 'A');
      expect(sil.byStringIndex['b'], 'BB');

      expect(sil.byStringIndex.indexOf('A'), 'a');
      expect(sil.byStringIndex.indexOf('BB'), 'b');

      expect(sil.byStringIndex.indexed.toList(), [(StringIndex('a'), 'A'), (StringIndex('b'), 'BB')]);
    });
  });
  
  group('Sil.list(...)', () {
    test('default equality and hash code', () {
      final sil = Sil.list(['A', 'B', 'B']);

      expect(sil.toList(), ['A', 'B']);

      expect(sil.byStringIndex[sil.byStringIndex.indexOf('A')!], 'A');
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('B')!], 'B');

      expect(sil.byStringIndex.indexOf('A')! < sil.byStringIndex.indexOf('B')!, true);
    });

    test('custom equality and hash code', () {
      final sil = Sil.list(['A', 'BB', 'BD'],
        equals: (a, b) => a.length == b.length,
        hash: (e) => 1,
      );

      expect(sil.toList(), ['A', 'BB']);

      expect(sil.byStringIndex[sil.byStringIndex.indexOf('A')!], 'A');
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('BB')!], 'BB');

      expect(sil.byStringIndex.indexOf('A')! < sil.byStringIndex.indexOf('BB')!, true);
    });
  });

  group('Sil(...)', () {
    test('default equality and hash code', () {
      final sil = Sil()..addAll(['A', 'B', 'B']);

      expect(sil.toList(), ['A', 'B']);

      expect(sil.byStringIndex[sil.byStringIndex.indexOf('A')!], 'A');
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('B')!], 'B');

      expect(sil.byStringIndex.indexOf('A')! < sil.byStringIndex.indexOf('B')!, true);
    });

    test('custom equality and hash code', () {
      final sil = Sil<String>(
        equals: (a, b) => a.length == b.length,
        hash: (e) => 1,
      )..addAll(['A', 'BB', 'BD']);

      expect(sil.toList(), ['A', 'BB']);

      expect(sil.byStringIndex[sil.byStringIndex.indexOf('A')!], 'A');
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('BN')!], 'BB');

      expect(sil.byStringIndex.indexOf('A')! < sil.byStringIndex.indexOf('BB')!, true);
    });
  });
  
  group('addAll(...)', () {
    test('duplicates in list', () {
      final sil = Sil()..addAll(['B', 'A', 'C', 'B']);
      expect(sil.toList(), ['B', 'A', 'C']);

      expect(sil.byStringIndex[sil.byStringIndex.indexOf('A')!], 'A');
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('B')!], 'B');
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('C')!], 'C');

      expect(sil.byStringIndex.indexOf('B')! < sil.byStringIndex.indexOf('A')!, true);
      expect(sil.byStringIndex.indexOf('A')! < sil.byStringIndex.indexOf('C')!, true);
    });

    test('duplicates in sil', () {
      final sil = Sil()..addAll(['B', 'A']);
      final before = sil.byStringIndex.indexOf('B');

      sil.addAll(['C', 'B']);

      final after = sil.byStringIndex.indexOf('B');

      expect(sil.toList(), ['B', 'A', 'C']);
      expect(before, after);

      expect(sil.byStringIndex[sil.byStringIndex.indexOf('A')!], 'A');
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('B')!], 'B');
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('C')!], 'C');

      expect(sil.byStringIndex.indexOf('B')! < sil.byStringIndex.indexOf('A')!, true);
      expect(sil.byStringIndex.indexOf('A')! < sil.byStringIndex.indexOf('C')!, true);
    });
  });

  group('add(...)', () {
    test('unique', () {
      final sil = Sil();

      expect(sil.add('B'), true);
      expect(sil.add('A'), true);

      expect(sil.toList(), ['B', 'A']);

      expect(sil.byStringIndex[sil.byStringIndex.indexOf('A')!], 'A');
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('B')!], 'B');

      expect(sil.byStringIndex.indexOf('B')! < sil.byStringIndex.indexOf('A')!, true);
    });

    test('duplicate', () {
      final sil = Sil();

      expect(sil.add('B'), true);
      final before = sil.byStringIndex.indexOf('B');

      expect(sil.add('A'), true);

      expect(sil.add('B'), false);
      final after = sil.byStringIndex.indexOf('B');

      expect(sil.toList(), ['B', 'A']);

      expect(before, after);
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('A')!], 'A');
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('B')!], 'B');

      expect(sil.byStringIndex.indexOf('B')! < sil.byStringIndex.indexOf('A')!, true);
    });
  });

  test('removeAll(...)', () {
    final sil = Sil()..addAll(['B', 'A', 'C']);
    expect(sil.toList(), ['B', 'A', 'C']);

    sil.removeAll(['B', 'C', 'D']);

    expect(sil.toList(), ['A']);

    expect(sil.byStringIndex[sil.byStringIndex.indexOf('A')!], 'A');
    expect(sil.byStringIndex.indexOf('B'), null);
    expect(sil.byStringIndex.indexOf('C'), null);
    expect(sil.byStringIndex.indexOf('D'), null);
    expect(sil.length, 1);
  });

  group('removeLast()', () {
    test('has elements', () {
      final sil = Sil()..addAll(['B', 'A']);
      expect(sil.toList(), ['B', 'A']);

      expect(sil.removeLast(), 'A');

      expect(sil.toList(), ['B']);

      expect(sil.byStringIndex[sil.byStringIndex.indexOf('B')!], 'B');
      expect(sil.byStringIndex.indexOf('A'), null);
      expect(sil.length, 1);
    });

    test('empty', () {
      final sil = Sil();
      expect(sil.removeLast, throwsRangeError);
    });
  });

  group('remove(...)', () {
    test('exists', () {
      final sil = Sil()..addAll(['B', 'A']);
      expect(sil.remove('B'), true);

      expect(sil.toList(), ['A']);
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('A')!], 'A');
      expect(sil.byStringIndex.indexOf('B'), null);
      expect(sil.length, 1);
    });

    test('does not exist', () {
      final sil = Sil()..addAll(['A']);
      expect(sil.remove('C'), false);

      expect(sil.toList(), ['A']);
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('A')!], 'A');
      expect(sil.byStringIndex.indexOf('C'), null);
      expect(sil.length, 1);
    });
  });

  group('removeWhere(...)', () {
    test('exists', () {
      final sil = Sil()..addAll(['B', 'A', 'C'])..removeWhere((value) => value == 'B' || value == 'C');

      expect(sil.toList(), ['A']);
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('A')!], 'A');
      expect(sil.byStringIndex.indexOf('B'), null);
      expect(sil.byStringIndex.indexOf('C'), null);
      expect(sil.length, 1);
    });

    test('empty', () {
      final sil = Sil()..removeWhere((value) => value == 'B' || value == 'C');

      expect(sil.toList(), []);
      expect(sil.byStringIndex.indexOf('B'), null);
      expect(sil.byStringIndex.indexOf('C'), null);
      expect(sil.length, 0);
    });
  });

  group('retainWhere(...)', () {
    test('exists', () {
      final sil = Sil()..addAll(['B', 'A', 'C'])..retainWhere((value) => value == 'B' || value == 'C');

      expect(sil.toList(), ['B', 'C']);
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('B')!], 'B');
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('C')!], 'C');
      expect(sil.byStringIndex.indexOf('A'), null);
      expect(sil.length, 2);
    });

    test('empty', () {
      final sil = Sil()..retainWhere((value) => value == 'B' || value == 'C');

      expect(sil.toList(), []);
      expect(sil.byStringIndex.indexOf('B'), null);
      expect(sil.byStringIndex.indexOf('C'), null);
      expect(sil.length, 0);
    });
  });

  test('clear()', () {
    final sil = Sil()..addAll(['B', 'A', 'C'])..clear();

    expect(sil.toList(), []);
    expect(sil.byStringIndex.indexOf('B'), null);
    expect(sil.byStringIndex.indexOf('A'), null);
    expect(sil.byStringIndex.indexOf('C'), null);
    expect(sil.length, 0);
  });

  group('contains(...)', () {
    test('default equality', () {
      final sil = Sil()..add('B');

      expect(sil.contains('B'), true);
      expect(sil.contains('C'), false);
    });

    test('custom equality', () {
      final sil = Sil<String>(
        equals: (a, b) => a.length == b.length,
        hash: (e) => 1,
      )..add('B');


      expect(sil.contains('B'), true);
      expect(sil.contains('C'), true);
      expect(sil.contains('CC'), false);
    });
  });

  group('elementAt(...)', () {
    test('exists', () {
      final sil = Sil()..addAll(['B', 'A', 'C']);

      expect(() => sil.elementAt(-1), throwsRangeError);
      expect(() => sil.elementAt(3), throwsRangeError);

      expect(sil.elementAt(0), 'B');
      expect(sil.elementAt(1), 'A');
      expect(sil.elementAt(2), 'C');
    });

    test('empty', () => expect(() => Sil().elementAt(0), throwsRangeError));
  });

  test('iterator', () {
    final sil = Sil()..addAll(['B', 'A', 'C']);

    final iterator = sil.iterator;
    final list = [];

    while (iterator.moveNext()) {
      list.add(iterator.current);
    }

    expect(list, ['B', 'A', 'C']);
  });

  group('first', () {
    test('exists', () {
      final sil = Sil()..addAll(['B', 'A', 'C'])..first = 'D';

      expect(sil.first, 'D');
      expect(sil.byStringIndex.indexOf('B'), null);
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('D')!], 'D');
      expect(sil.byStringIndex.indexOf('D')! < sil.byStringIndex.indexOf('A')!, true);
    });

    test('exists', () {
      final sil = Sil()..addAll(['B', 'A', 'C']);
      final before = sil.byStringIndex.indexOf('B');

      sil.first = 'B';
      final after = sil.byStringIndex.indexOf('B');

      expect(sil.first, 'B');
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('B')!], 'B');
      expect(before, after);
    });

    test('empty', () => expect(() => Sil().first = 'B', throwsStateError));
  });

  group('last', () {
    test('exists', () {
      final sil = Sil()..addAll(['B', 'A', 'C'])..last = 'D';

      expect(sil.last, 'D');
      expect(sil.byStringIndex.indexOf('C'), null);
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('D')!], 'D');
      expect(sil.byStringIndex.indexOf('A')! < sil.byStringIndex.indexOf('D')!, true);
    });

    test('exists', () {
      final sil = Sil()..addAll(['B', 'A', 'C']);
      final before = sil.byStringIndex.indexOf('C');

      sil.last = 'C';
      final after = sil.byStringIndex.indexOf('C');

      expect(sil.last, 'C');
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('C')!], 'C');
      expect(before, after);
    });

    test('empty', () => expect(() => Sil().last = 'B', throwsStateError));
  });

  test('toString()', () {
    final sil = Sil.map({StringIndex('a'): 'A', StringIndex('d'): 'B', StringIndex('b'): 'B'});
    expect(sil.toString(), '[(a: A), (b: B)]');
  });
}
