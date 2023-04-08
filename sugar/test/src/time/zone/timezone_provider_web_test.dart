@TestOn('browser')
library;

import 'package:sugar/time.dart';

import 'package:test/test.dart';

void main() {
  test('provider', () {
    final timezone = defaultTimezoneProvider();

    expect(Timezone.supported.contains(timezone), true);
    expect(timezone, isNot('Factory'));
  });
}
