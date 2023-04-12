import 'package:sugar/core.dart';
import 'package:test/test.dart';

class Box with Orderable<Box> {
  final int key;
  final int value;

  Box(this.key, [this.value = 0]);

  @override
  int compareTo(Box other) => key.compareTo(other.key);

  @override
  int get hashValue => key.hashCode;

  @override
  String toString() => 'Box{key: $key, value: $value}';
}

class Value {
  final int value;

  Value(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Value && runtimeType == other.runtimeType && value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Value{value: $value}';
}

void main() {
  group('Orderable', () {
    test('smaller < larger', () => expect(Box(1) < Box(2), true));

    test('same < same', () => expect(Box(1) < Box(1), false));

    test('larger < smaller', () => expect(Box(2) < Box(1), false));


    test('smaller > larger', () => expect(Box(1) > Box(2), false));

    test('same > same', () => expect(Box(1) > Box(1), false));

    test('larger > smaller', () => expect(Box(2) > Box(1), true));


    test('smaller <= larger', () => expect(Box(1) <= Box(2), true));

    test('same <= same', () => expect(Box(1) <= Box(1), true));

    test('larger <= smaller', () => expect(Box(2) <= Box(1), false));


    test('smaller >= larger', () => expect(Box(1) >= Box(2), false));

    test('same >= same', () => expect(Box(1) >= Box(1), true));

    test('larger >= smaller', () => expect(Box(2) >= Box(1), true));

    group('equality', () {
      final box = Box(1);

      for (final entry in [
        MapEntry(Box(1), true),
        MapEntry(Box(1, 5), true),
        MapEntry(Box(2), false),
        MapEntry(Box(2, 5), false),
      ]) {
        final other = entry.key;
        final equal = entry.value;

        test('$box == $other, $equal', () => expect(box == other, equal));

        test('$box hashCode == $other hashCode, $equal', () => expect(box.hashCode == other.hashCode, equal));
      }
    });
    test('smaller >= larger', () => expect(Box(1) >= Box(2), false));

    test('same >= same', () => expect(Box(1) >= Box(1), true));

    test('larger >= smaller', () => expect(Box(2) >= Box(1), true));
  });

  group('min(...)', () {
    group('non-comparables', () {
      test('by specified, left less than right', () => expect(min(Value(1), Value(2), by: (e) => e.value), Value(1)));

      test('by specified, left equal right', () => expect(min(Value(1), Value(1), by: (e) => e.value), Value(1)));

      test('by specified, left greater than right', () => expect(min(Value(2), Value(1), by: (e) => e.value), Value(1)));

      test('by not specified', () => expect(() => min(Value(1), Value(2)), throwsA(const TypeMatcher<TypeError>())));
    });

    group('comparables', () {
      test('left less than right', () => expect(min(Box(1), Box(2)), Box(1)));

      test('left equal right', () => expect(min(Box(1), Box(1)), Box(1)));

      test('left greater than right', () => expect(min(Box(2), Box(1)), Box(1)));
      
      
      test('by specified, left less than right', () => expect(min(Box(1, 2), Box(2, 1), by: (e) => e.value), Box(2, 1)));

      test('by specified, left equal right', () => expect(min(Box(1, 2), Box(1, 2), by: (e) => e.value), Box(1, 2)));

      test('by specified, left greater than right', () => expect(min(Box(2, 1), Box(1, 2), by: (e) => e.value), Box(2, 1)));
    });
  });

  group('max(...)', () {
    group('non-comparables', () {
      test('by specified, left less than right', () => expect(max(Value(1), Value(2), by: (e) => e.value), Value(2)));

      test('by specified, left equal right', () => expect(max(Value(1), Value(1), by: (e) => e.value), Value(1)));

      test('by specified, left greater than right', () => expect(max(Value(2), Value(1), by: (e) => e.value), Value(2)));

      test('by not specified', () => expect(() => max(Value(1), Value(2)), throwsA(const TypeMatcher<TypeError>())));
    });

    group('comparables', () {
      test('left less than right', () => expect(max(Box(1), Box(2)), Box(2)));

      test('left equal right', () => expect(max(Box(1), Box(1)), Box(1)));

      test('left greater than right', () => expect(max(Box(2), Box(1)), Box(2)));


      test('by specified, left less than right', () => expect(max(Box(1, 2), Box(2, 1), by: (e) => e.value), Box(1, 2)));

      test('by specified, left equal right', () => expect(max(Box(1, 2), Box(1, 2), by: (e) => e.value), Box(1, 2)));

      test('by specified, left greater than right', () => expect(max(Box(2, 1), Box(1, 2), by: (e) => e.value), Box(1, 2)));
    });
  });

  group('Comparators', () {
    group('by(...)', () {
      final compare = Comparators.by<Value>((e) => e.value);
      
      test('left less than right', () => expect(compare(Value(1), Value(2)), -1));

      test('left equal right', () => expect(compare(Value(1), Value(1)), 0));

      test('less greater than right', () => expect(compare(Value(2), Value(1)), 1));
    });

    group('reverse(...)', () {
      final compare = Comparators.by<Value>((e) => e.value).reverse();

      test('left less than right', () => expect(compare(Value(1), Value(2)), 1));

      test('left equal right', () => expect(compare(Value(1), Value(1)), 0));

      test('less greater than right', () => expect(compare(Value(2), Value(1)), -1));
    });

    group('and(...)', () {
      final compare = Comparators.by<Box>((e) => e.key).and(Comparators.by((e) => e.value));

      test('left less than right', () => expect(compare(Box(1, 2), Box(2, 1)), -1));

      test('left equal right', () => expect(compare(Box(1, 1), Box(1, 1)), 0));

      test('left equal right, tiebreaker', () => expect(compare(Box(1, 1), Box(1, 2)), -1));

      test('less greater than right', () => expect(compare(Box(2, 1), Box(1, 2)), 1));
    });
  });

  group('ComparableDateTimes', () {
    test('smaller < larger', () => expect(DateTime(1) < DateTime(2), true));

    test('same < same', () => expect(DateTime(1) < DateTime(1), false));

    test('larger < smaller', () => expect(DateTime(2) < DateTime(1), false));


    test('smaller > larger', () => expect(DateTime(1) > DateTime(2), false));

    test('same > same', () => expect(DateTime(1) > DateTime(1), false));

    test('larger > smaller', () => expect(DateTime(2) > DateTime(1), true));


    test('smaller <= larger', () => expect(DateTime(1) <= DateTime(2), true));

    test('same <= same', () => expect(DateTime(1) <= DateTime(1), true));

    test('larger <= smaller', () => expect(DateTime(2) <= DateTime(1), false));


    test('smaller >= larger', () => expect(DateTime(1) >= DateTime(2), false));

    test('same >= same', () => expect(DateTime(1) >= DateTime(1), true));

    test('larger >= smaller', () => expect(DateTime(2) >= DateTime(1), true));
  });
}
