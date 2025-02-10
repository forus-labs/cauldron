import 'package:test/test.dart';

import 'package:sugar/sugar.dart';

void main() {
  final timezone = UniversalTimezoneProvider()['Etc/GMT-8']!;

  test('at(...)', () {
    final microseconds = timezone.convert(
        local: DateTime.utc(2023, 5, 9, 10).microsecondsSinceEpoch);
    expect(microseconds, DateTime.utc(2023, 5, 9, 2).microsecondsSinceEpoch);
  });

  group('span(...)', () {
    final offset = timezone.offset(at: DateTime.utc(2023, 5, 4).microsecond);
    test('offset', () => expect(offset, Offset(8)));
  });

  test('toString()', () {
    expect(timezone.name, 'Etc/GMT-8');
    expect(timezone.toString(), 'Etc/GMT-8');
  });
}
