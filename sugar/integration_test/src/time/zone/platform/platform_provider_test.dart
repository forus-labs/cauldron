import 'package:sugar/sugar.dart';
import 'package:test/test.dart';

/// These tests should be ran using the shell/bat scripts in the same folder.
void main() {
  test('defaultPlatformTimezoneProvider() return current timezone', () {
    final timezones = UniversalTimezoneProvider();
    final timezone = defaultPlatformTimezoneProvider();

    expect(timezones.containsKey(timezone), true);
    expect(timezone, isNot('Factory'));
  }, testOn: 'windows');

  test('defaultPlatformTimezoneProvider() return current timezone', () {
    final timezones = UniversalTimezoneProvider();
    final timezone = defaultPlatformTimezoneProvider();

    expect(timezones.containsKey(timezone), true);
    expect(timezone, 'Asia/Tokyo');
  }, testOn: '!windows');

  group('posix', () {
    test('defaultPlatformTimezoneProvider() known TZ environment variable', () {
      final timezones = UniversalTimezoneProvider();
      final timezone = defaultPlatformTimezoneProvider();

      expect(timezones.containsKey(timezone), true);
      expect(timezone, 'Mexico/BajaSur');
    });

    test('defaultPlatformTimezoneProvider() unknown TZ environment variable',
        () {
      final timezones = UniversalTimezoneProvider();
      final timezone = defaultPlatformTimezoneProvider();

      expect(timezones.containsKey(timezone), true);
      expect(timezone, 'Asia/Tokyo');
    });
  }, testOn: 'posix');
}
