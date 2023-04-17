@Tags(['platform-specific'])
library;

import 'package:sugar/time.dart';

import 'package:test/test.dart';

void main() {
  test('defaultTimezoneProvider()', () {
    final timezone = defaultPlatformTimezone();

    expect(TimezoneRules.supported.contains(timezone), true);
    expect(timezone, isNot('Factory'));
  });
}
