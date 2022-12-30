import 'package:sugar/collection.dart';
import 'package:test/test.dart';

void main() {

  group('ListMove', () {
    group('toList()', () {
      test('empty source', () {
        final source = [];
        final result = source.move(where: (e) => true).toList();

        expect(source, []);
        expect(result, []);
      });

      test('emptied source', () {
        final source = [1];
        final result = source.move(where: (e) => true).toList();

        expect(source, []);
        expect(result, [1]);
      });

      test('empty result', () {
        final source = [1];
        final result = source.move(where: (e) => false).toList();

        expect(source, [1]);
        expect(result, []);
      });

      test('move alternating', () {
        final source = [1, 2, 3, 4, 5];
        final result = source.move(where: (e) => e.isOdd).toList();

        expect(source, [2, 4]);
        expect(result, [1, 3, 5]);
      });

      test('move duplicates', () {
        final source = [1, 2, 3, 1, 4, 5];
        final result = source.move(where: (e) => e.isOdd).toList();

        expect(source, [2, 4]);
        expect(result, [1, 3, 1, 5]);
      });

      test('move range', () {
        final source = [1, 3, 5, 2, 4];
        final result = source.move(where: (e) => e.isOdd).toList();

        expect(source, [2, 4]);
        expect(result, [1, 3, 5]);
      });

      test('predicate modifies source', () {
        final source = [1, 2, 3, 4, 5];
        expect(() => source.move(where: source.remove).toList(), throwsConcurrentModificationError);
      });
    });

    group('toSet()', () {
      test('empty source', () {
        final source = [];
        final result = source.move(where: (e) => true).toSet();

        expect(source, []);
        expect(result, <dynamic>{});
      });

      test('emptied source', () {
        final source = [1];
        final result = source.move(where: (e) => true).toSet();

        expect(source, []);
        expect(result, {1});
      });

      test('empty result', () {
        final source = [1];
        final result = source.move(where: (e) => false).toSet();

        expect(source, [1]);
        expect(result, <int>{});
      });

      test('move alternating', () {
        final source = [1, 2, 3, 4, 5];
        final result = source.move(where: (e) => e.isOdd).toSet();

        expect(source, [2, 4]);
        expect(result, {1, 3, 5});
      });

      test('move duplicates', () {
        final source = [1, 2, 3, 1, 4, 5];
        final result = source.move(where: (e) => e.isOdd).toSet();

        expect(source, [2, 4]);
        expect(result, {1, 3, 5});
      });

      test('move range', () {
        final source = [1, 3, 5, 2, 4];
        final result = source.move(where: (e) => e.isOdd).toSet();

        expect(source, [2, 4]);
        expect(result, {1, 3, 5});
      });

      test('predicate modifies source', () {
        final source = [1, 2, 3, 4, 5];
        expect(() => source.move(where: source.remove).toSet(), throwsConcurrentModificationError);
      });
    });

    group('collect()', () {
      test('empty source', () {
        final source = [];
        final result = [];
        source.move(where: (e) => true).collect(result.add);

        expect(source, []);
        expect(result, []);
      });

      test('emptied source', () {
        final source = [1];
        final result = [];
        source.move(where: (e) => true).collect(result.add);

        expect(source, []);
        expect(result, [1]);
      });

      test('empty result', () {
        final source = [1];
        final result = [];
        source.move(where: (e) => false).collect(result.add);

        expect(source, [1]);
        expect(result, []);
      });

      test('move alternating', () {
        final source = [1, 2, 3, 4, 5];
        final result = [];
        source.move(where: (e) => e.isOdd).collect(result.add);

        expect(source, [2, 4]);
        expect(result, [1, 3, 5]);
      });

      test('move duplicates', () {
        final source = [1, 2, 3, 1, 4, 5];
        final result = [];
        source.move(where: (e) => e.isOdd).collect(result.add);

        expect(source, [2, 4]);
        expect(result, [1, 3, 1, 5]);
      });

      test('move range', () {
        final source = [1, 3, 5, 2, 4];
        final result = [];
        source.move(where: (e) => e.isOdd).collect(result.add);

        expect(source, [2, 4]);
        expect(result, [1, 3, 5]);
      });

      test('predicate modifies source', () {
        final source = [1, 2, 3, 4, 5];
        final result = [];
        expect(() => source.move(where: source.remove).collect(result.add), throwsConcurrentModificationError);
      });

      test('collect modifies source', () {
        final source = [1, 2, 3, 4, 5];
        expect(() => source.move(where: (e) => true).collect(source.remove), throwsConcurrentModificationError);
      });
    });
  });

  group('SetMove', () {
    group('toSet()', () {
      test('empty source', () {
        final source = <int>{};
        final result = source.move(where: (e) => true).toSet();

        expect(source, <int>{});
        expect(result, <int>{});
      });

      test('emptied source', () {
        final source = {1};
        final result = source.move(where: (e) => true).toSet();

        expect(source, <int>{});
        expect(result, {1});
      });

      test('empty result', () {
        final source = {1};
        final result = source.move(where: (e) => false).toSet();

        expect(source, {1});
        expect(result, <int>{});
      });

      test('move', () {
        final source = {1, 2, 3, 4, 5};
        final result = source.move(where: (e) => e.isOdd).toSet();

        expect(source, {2, 4});
        expect(result, {1, 3, 5});
      });

      test('predicate modifies source', () {
        final source = {1, 2, 3, 4, 5};
        expect(() => source.move(where: source.remove).toSet(), throwsConcurrentModificationError);
      });
    });

    group('collect()', () {
      test('empty source', () {
        final source = <int>{};
        final result = <int>{};
        source.move(where: (e) => true).collect(result.add);

        expect(source, <int>{});
        expect(result, <int>{});
      });

      test('emptied source', () {
        final source = {1};
        final result = <int>{};
        source.move(where: (e) => true).collect(result.add);

        expect(source, <int>{});
        expect(result, {1});
      });

      test('empty result', () {
        final source = {1};
        final result = <int>{};
        source.move(where: (e) => false).collect(result.add);

        expect(source, {1});
        expect(result, <int>{});
      });

      test('move', () {
        final source = {1, 2, 3, 4, 5};
        final result = <int>{};
        source.move(where: (e) => e.isOdd).collect(result.add);

        expect(source, {2, 4});
        expect(result, {1, 3, 5});
      });

      test('predicate modifies source', () {
        final source = {1, 2, 3, 4, 5};
        final result = <int>{};
        expect(() => source.move(where: source.remove).collect(result.add), throwsConcurrentModificationError);
      });

      test('collect modifies source', () {
        final source = {1, 2, 3, 4, 5};
        expect(() => source.move(where: (e) => true).collect(source.remove), throwsConcurrentModificationError);
      });
    });
  });

}
