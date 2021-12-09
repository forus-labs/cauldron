import 'package:sugar/sugar.dart';
import 'package:test/test.dart';

void main() {
  group('Debounce', () {
    test('initial > cap', () {
      expect(() => Debounce(initial: 2, cap: 1), throwsA(predicate((e) => e is AssertionError && e.message == 'Initial value (2) should be <= cap (1)')));
    });

    test('initial <= 0', () {
      expect(() => Debounce(initial: 0, cap: 1), throwsA(predicate((e) => e is AssertionError && e.message == 'Initial value (0) should be > 0')));
    });

    test('cap > (2^32) * 2', () {
      expect(() => Debounce(initial: 1, cap: 8589934593), throwsA(predicate((e) => e is AssertionError && e.message == 'Cap (8589934593) should be <= (2^32) * 2')));
    });
  });

  test('debounce increases tries', () {
    final debounce = Debounce(initial: 8589934592, cap: 8589934592)..debounce();
    expect(debounce.tries, 1);
  });

  group('pending', () {
    test('true', () {
      final debounce = Debounce(initial: 8589934592, cap: 8589934592)..debounce();
      expect(debounce.pending, true);
    });

    test('false', () {
      final debounce = Debounce(initial: 1, cap: 1);
      expect(debounce.pending, false);
    });
  });

  test('clear', () {
    final debounce = Debounce(initial: 1, cap: 1)..debounce();
    expect(debounce.tries, 1);

    debounce.clear();
    expect(debounce.tries, 0);
  });

  group('timeout', () {
    test('caps', () {
      final debounce = Debounce(initial: 8589934591, cap: 8589934592)..debounce()..debounce();
      expect(debounce.timeout, 8589934592);
    });
  });
}
