import 'package:sugar/src/time/zone/timezone_provider.dart';
import 'package:sugar/sugar.dart';
import 'package:test/test.dart';

void main() {
  group('windows', () {
    test('defaultPlatformTimezoneProvider(), not factory', () {
      final timezones = DefaultTimezoneProvider();
      final timezone = defaultPlatformTimezoneProvider();

      expect(timezones.containsKey(timezone), true);
      expect(timezone, isNot('Factory'));
    });

  }, testOn: 'windows');

  group('posix', () {
    test('defaultPlatformTimezoneProvider() known TZ environment variable', () {
      final timezones = DefaultTimezoneProvider();
      final timezone = defaultPlatformTimezoneProvider();

      expect(timezones.containsKey(timezone), true);
      expect(timezone, 'Mexico/BajaSur');
    });
  }, testOn: 'posix');
}
