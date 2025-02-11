import 'package:sugar/sugar.dart';
import 'package:test/test.dart';

void main() {
  group('EmbeddedTimezoneProvider', () {
    final provider = EmbeddedTimezoneProvider();

    test('existing timezone',
        () => expect(provider['America/Detroit']?.name, 'America/Detroit'));

    test('non-existing timezone', () => expect(provider['invalid'], null));

    test('keys contains timezone',
        () => expect(provider.keys.contains('America/Detroit'), true));

    test('keys does not contain timezone',
        () => expect(provider.keys.contains('invalid'), false));
  });
}
