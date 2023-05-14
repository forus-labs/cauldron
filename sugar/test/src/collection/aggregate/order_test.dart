import 'package:sugar/collection_aggregate.dart';

import 'package:test/test.dart';

void main() {

  group('ascending', () {
    test('empty', () => expect(<int>[].order(by: (e) => e).ascending, []));

    test('single value', () => expect([(1,)].order(by: (e) => e.$1).ascending, [(1,)]));

    test('multiple values', () => expect([(1,), (3,), (2,)].order(by: (e) => e.$1).ascending, [(1,), (2,), (3,)]));

    test('multiple same values', () => expect([(1,), (3,), (2,), (3,)].order(by: (e) => e.$1).ascending, [(1,), (2,), (3,), (3,)]));
  });

  group('descending', () {
    test('empty', () => expect(<int>[].order(by: (e) => e).descending, []));

    test('single value', () => expect([(1,)].order(by: (e) => e.$1).descending, [(1,)]));

    test('multiple values', () => expect([(1,), (3,), (2,)].order(by: (e) => e.$1).descending, [(3,), (2,), (1,)]));

    test('multiple same values', () => expect([(1,), (3,), (2,), (3,)].order(by: (e) => e.$1).descending, [(3,), (3,), (2,), (1,)]));
  });

  group('min', () {
    test('empty', () => expect(<int>[].order(by: (e) => e).min, null));

    test('single value', () => expect([(1,)].order(by: (e) => e.$1).min, (1,)));

    test('multiple values, min first', () => expect([(1,), (3,), (2,)].order(by: (e) => e.$1).min, (1,)));

    test('multiple values, min not first', () => expect([(3,), (1,), (2,)].order(by: (e) => e.$1).min, (1,)));

    test('multiple same values', () => expect([(1,), (3,), (2,), (1,)].order(by: (e) => e.$1).min, (1,)));
  });

  group('max', () {
    test('empty', () => expect(<int>[].order(by: (e) => e).max, null));

    test('single value', () => expect([(1,)].order(by: (e) => e.$1).max, (1,)));

    test('multiple values, max first', () => expect([(3,), (1,), (2,)].order(by: (e) => e.$1).max, (3,)));

    test('multiple values, max not first', () => expect([(1,), (3,), (2,)].order(by: (e) => e.$1).max, (3,)));

    test('multiple same values', () => expect([(3,), (1,), (2,), (3,)].order(by: (e) => e.$1).max, (3,)));
  });

}
