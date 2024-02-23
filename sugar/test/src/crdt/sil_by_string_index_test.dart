import 'package:sugar/sugar.dart';
import 'package:test/test.dart';

void main() {
  group('firstIndexAfter(...)', () {
    test('after first', () {
      final sil = Sil.map({StringIndex('a'): 'A', StringIndex('b'): 'B'}).byStringIndex;
      expect(sil.firstIndexAfter(StringIndex('a')), 'b');
    });

    test('after first imprecise', () {
      final sil = Sil.map({StringIndex('a'): 'A', StringIndex('b'): 'B'}).byStringIndex;
      expect(sil.firstIndexAfter(StringIndex('aa')), 'b');
    });


    test('after last', () {
      final sil = Sil.map({StringIndex('a'): 'A', StringIndex('b'): 'B'}).byStringIndex;
      expect(sil.firstIndexAfter(StringIndex('b')), null);
    });

    test('after last imprecise', () {
      final sil = Sil.map({StringIndex('a'): 'A', StringIndex('b'): 'B'}).byStringIndex;
      expect(sil.firstIndexAfter(StringIndex('bb')), null);
    });
  });

  group('firstElementAfter(...)', () {
    test('after first', () {
      final sil = Sil.map({StringIndex('a'): 'A', StringIndex('b'): 'B'}).byStringIndex;
      expect(sil.firstElementAfter(StringIndex('a')), 'B');
    });

    test('after first imprecise', () {
      final sil = Sil.map({StringIndex('a'): 'A', StringIndex('b'): 'B'}).byStringIndex;
      expect(sil.firstElementAfter(StringIndex('aa')), 'B');
    });


    test('after last', () {
      final sil = Sil.map({StringIndex('a'): 'A', StringIndex('b'): 'B'}).byStringIndex;
      expect(sil.firstElementAfter(StringIndex('b')), null);
    });

    test('after last imprecise', () {
      final sil = Sil.map({StringIndex('a'): 'A', StringIndex('b'): 'B'}).byStringIndex;
      expect(sil.firstElementAfter(StringIndex('bb')), null);
    });
  });


  group('lastIndexBefore(...)', () {
    test('after first', () {
      final sil = Sil.map({StringIndex('a'): 'A', StringIndex('b'): 'B'}).byStringIndex;
      expect(sil.lastIndexBefore(StringIndex('b')), 'a');
    });

    test('after first imprecise', () {
      final sil = Sil.map({StringIndex('a'): 'A', StringIndex('b'): 'B'}).byStringIndex;
      expect(sil.lastIndexBefore(StringIndex('aa')), 'a');
    });


    test('after last', () {
      final sil = Sil.map({StringIndex('a'): 'A', StringIndex('b'): 'B'}).byStringIndex;
      expect(sil.lastIndexBefore(StringIndex('a')), null);
    });

    test('after last imprecise', () {
      final sil = Sil.map({StringIndex('a'): 'A', StringIndex('b'): 'B'}).byStringIndex;
      expect(sil.lastIndexBefore(StringIndex('00')), null);
    });
  });

  group('lastElementBefore(...)', () {
    test('after first', () {
      final sil = Sil.map({StringIndex('a'): 'A', StringIndex('b'): 'B'}).byStringIndex;
      expect(sil.lastElementBefore(StringIndex('b')), 'A');
    });

    test('after first imprecise', () {
      final sil = Sil.map({StringIndex('a'): 'A', StringIndex('b'): 'B'}).byStringIndex;
      expect(sil.lastElementBefore(StringIndex('aa')), 'A');
    });


    test('after last', () {
      final sil = Sil.map({StringIndex('a'): 'A', StringIndex('b'): 'B'}).byStringIndex;
      expect(sil.lastElementBefore(StringIndex('a')), null);
    });

    test('after last imprecise', () {
      final sil = Sil.map({StringIndex('a'): 'A', StringIndex('b'): 'B'}).byStringIndex;
      expect(sil.lastElementBefore(StringIndex('00')), null);
    });
  });


  group('indexOf(...)', () {
    test('default equality', () {
      final sil = Sil.map({StringIndex('a'): 'A'}).byStringIndex;
      expect(sil.indexOf('A'), 'a');
    });

    test('custom equality', () {
      final sil = Sil.map(
        {StringIndex('a'): 'A'},
        equals: (a, b) => a.length == b.length,
        hash: (e) => 1,
      ).byStringIndex;

      expect(sil.indexOf('B'), 'a');
    });
  });

  group('indexWhere(...)', () {
    test('start from a', () {
      final sil = Sil.map({StringIndex('a'): 'A', StringIndex('b'): 'BB', StringIndex('c'): 'C'}).byStringIndex;
      expect(sil.indexWhere((e) => e.length == 1), 'a');
    });

    test('start from ab', () {
      final sil = Sil.map({StringIndex('a'): 'A', StringIndex('b'): 'BB', StringIndex('c'): 'C'}).byStringIndex;
      expect(sil.indexWhere((e) => e.length == 1, 'ab'), 'c');
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
    test('end at end', () {
      final sil = Sil.map({StringIndex('a'): 'A', StringIndex('b'): 'BB', StringIndex('c'): 'C'}).byStringIndex;
      expect(sil.lastIndexWhere((e) => e.length == 1), 'c');
    });

    test('end at bc', () {
      final sil = Sil.map({StringIndex('a'): 'A', StringIndex('b'): 'BB', StringIndex('c'): 'C'}).byStringIndex;
      expect(sil.lastIndexWhere((e) => e.length == 1, 'bc'), 'a');
    });

    test('not found', () {
      final sil = Sil.map({StringIndex('a'): 'A', StringIndex('b'): 'BB', StringIndex('c'): 'C'}).byStringIndex;
      expect(sil.lastIndexWhere((e) => false), null);
    });

    test('empty', () {
      final sil = Sil().byStringIndex;
      expect(sil.lastIndexWhere((e) => true), null);
    });
  });


  group('removeAt(...)', () {
    test('remove at start', () {
      final sil = Sil.map({StringIndex('a'): 'A', StringIndex('b'): 'B', StringIndex('c'): 'C'});
      expect(sil.byStringIndex.removeAt('a'), 'A');

      expect(sil.toList(), ['B', 'C']);
      expect(sil.byStringIndex.indexOf('A'), null);
      expect(sil.length, 2);
    });

    test('remove in middle', () {
      final sil = Sil.map({StringIndex('a'): 'A', StringIndex('b'): 'B', StringIndex('c'): 'C'});
      expect(sil.byStringIndex.removeAt('b'), 'B');

      expect(sil.toList(), ['A', 'C']);
      expect(sil.byStringIndex.indexOf('B'), null);
      expect(sil.length, 2);
    });

    test('remove at end', () {
      final sil = Sil.map({StringIndex('a'): 'A', StringIndex('b'): 'B', StringIndex('c'): 'C'});
      expect(sil.byStringIndex.removeAt('c'), 'C');

      expect(sil.toList(), ['A', 'B']);
      expect(sil.byStringIndex.indexOf('C'), null);
      expect(sil.length, 2);
    });

    test('empty', () {
      final sil = Sil();
      expect(sil.byStringIndex.removeAt('E'), null);
    });

    test('index too small', () {
      final sil = Sil.map({StringIndex('a'): 'A', StringIndex('b'): 'B', StringIndex('c'): 'C'});
      expect(sil.byStringIndex.removeAt('0'), null);
    });

    test('index too large', () {
      final sil = Sil.map({StringIndex('a'): 'A', StringIndex('b'): 'B', StringIndex('c'): 'C'});
      expect(sil.byStringIndex.removeAt('d'), null);
    });
  });
  
  
  test('E []', () {
    final sil = Sil.map({StringIndex('a'): 'A', StringIndex('b'): 'B', StringIndex('c'): 'C'});
    expect(sil.byStringIndex['a'], 'A');
    expect(sil.byStringIndex['ab'], null);
    expect(sil.byStringIndex['d'], null);
  });

  group('[]=', () {
    test('element already exists, default equality', () {
      final sil = Sil.map({StringIndex('a'): 'A', StringIndex('b'): 'B', StringIndex('c'): 'C'});
      sil.byStringIndex[StringIndex('d')] = 'A';
    });

    test('element already exists, custom equality', () {
      final sil = Sil.map(
        {StringIndex('a'): 'A', StringIndex('b'): 'B', StringIndex('c'): 'C'},
        equals: (a, b) => a.length == b.length,
        hash: (e) => 1,
      );

      sil.byStringIndex[StringIndex('d')] = 'A';
    });

    test('index does not exist, has element after', () {
      final sil = Sil.map({StringIndex('a'): 'A', StringIndex('b'): 'B', StringIndex('c'): 'C'});
      sil.byStringIndex[StringIndex('bc')] = 'D';

      expect(sil.toList(), ['A', 'B', 'D', 'C']);
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('D')!], 'D');
      expect(sil.byStringIndex.indexOf('B')! < sil.byStringIndex.indexOf('D')!, true);
      expect(sil.byStringIndex.indexOf('D')! < sil.byStringIndex.indexOf('C')!, true);
      expect(sil.length, 4);
    });

    test('index does not exist, no element after', () {
      final sil = Sil.map({StringIndex('a'): 'A', StringIndex('b'): 'B', StringIndex('c'): 'C'});
      sil.byStringIndex[StringIndex('f')] = 'D';

      expect(sil.toList(), ['A', 'B', 'C', 'D']);
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('D')!], 'D');
      expect(sil.byStringIndex.indexOf('C')! < sil.byStringIndex.indexOf('D')!, true);
      expect(sil.length, 4);
    });


    test('index exists, has element after', () {
      final sil = Sil.map({StringIndex('a'): 'A', StringIndex('b'): 'B', StringIndex('c'): 'C'});
      sil.byStringIndex[StringIndex('b')] = 'D';

      expect(sil.toList(), ['A', 'D', 'C']);
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('D')!], 'D');
      expect(sil.byStringIndex.indexOf('A')! < sil.byStringIndex.indexOf('D')!, true);
      expect(sil.byStringIndex.indexOf('D')! < sil.byStringIndex.indexOf('C')!, true);
      expect(sil.length, 3);
    });

    test('index exists, no element after', () {
      final sil = Sil.map({StringIndex('a'): 'A', StringIndex('b'): 'B', StringIndex('c'): 'C'});
      sil.byStringIndex[StringIndex('c')] = 'D';

      expect(sil.toList(), ['A', 'B', 'D']);
      expect(sil.byStringIndex[sil.byStringIndex.indexOf('D')!], 'D');
      expect(sil.byStringIndex.indexOf('B')! < sil.byStringIndex.indexOf('D')!, true);
      expect(sil.length, 3);
    });
  });

  test('indexed', () {
    final sil = Sil.map({StringIndex('a'): 'A', StringIndex('b'): 'B', StringIndex('c'): 'C'});
    expect(sil.byStringIndex.indexed.toList(), [('a', 'A'), ('b', 'B'), ('c', 'C')]);
  });
}
