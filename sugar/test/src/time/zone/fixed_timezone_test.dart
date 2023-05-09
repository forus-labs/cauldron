import 'package:sugar/src/time/zone/timezone_provider.dart';
import 'package:sugar/sugar.dart';
import 'package:test/test.dart';

void main() {
  final timezone = DefaultTimezoneProvider()['Etc/GMT-8']!;

  test('at(...)', () {
    final entry = timezone.convert(local: DateTime.utc(2023, 5, 9, 10).microsecondsSinceEpoch); // TODO: Dart 3
    expect(entry.key, DateTime.utc(2023, 5, 9, 2).microsecondsSinceEpoch);
    expect(entry.value.offset, Offset(8));
  });
  
  group('span(...)', () {
    final span = timezone.span(at: DateTime.utc(2023, 5, 4).microsecond);

    test('abbreviation', () => expect(span.abbreviation, '+08'));
    
    test('start', () => expect(span.start, TimezoneSpan.range.min));

    test('end', () => expect(span.end, TimezoneSpan.range.max));
    
    test('dst', () => expect(span.dst, false));

    test('offset', () => expect(span.offset, Offset(8)));
  });

  test('toString()', () {
    expect(timezone.name, 'Etc/GMT-8');
    expect(timezone.toString(), 'Etc/GMT-8');
  });
}
