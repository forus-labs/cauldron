import 'package:test/test.dart';

import 'package:sugar/src/time/zone/timezone_provider.dart';

void main() {
  group('DefaultTimezoneProvider', () {
    final provider = DefaultTimezoneProvider();

    test('existing timezone', () => expect(provider['America/Detroit']?.name, 'America/Detroit'));

    test('non-existing timezone', () => expect(provider['invalid'], null));


    test('keys contains timezone', () => expect(provider.keys.contains('America/Detroit'), true));

    test('keys does not contain timezone', () => expect(provider.keys.contains('invalid'), false));
  });
}
