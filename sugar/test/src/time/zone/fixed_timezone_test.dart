import 'package:sugar/src/time/zone/providers/embedded/embedded_timezone_provider.dart';
import 'package:test/test.dart';

import 'package:sugar/sugar.dart';

void main() {
  final timezone = EmbeddedTimezoneProvider()['Etc/GMT-8']!;

  test('at(...)', () {
    final (microseconds, TimezoneSpan(:offset)) = timezone.convert(2023, 5, 9, 10);
    expect(microseconds, DateTime.utc(2023, 5, 9, 2).microsecondsSinceEpoch);
    expect(offset, Offset(8));
  });

  group('span(...)', () {
    final span = timezone.span(at: DateTime.utc(2023, 5, 4).microsecond);

    test('abbreviation', () => expect(span.abbreviation, '+0800'));

    test('start', () => expect(span.start, TimezoneSpan.range.min.value));

    test('end', () => expect(span.end, TimezoneSpan.range.max.value));

    test('dst', () => expect(span.dst, false));

    test('offset', () => expect(span.offset, Offset(8)));
  });

  test('toString()', () {
    expect(timezone.name, 'Etc/GMT-8');
    expect(timezone.toString(), 'Etc/GMT-8');
  });
}
