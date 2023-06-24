import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:stevia/stevia.dart';
import 'package:sugar/sugar.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  test('timezone is set', () async {
    Timezone.platformTimezoneProvider = await flutterPlatformTimezoneProvider();
    expect(ZonedDateTime.now().timezone.name, isNot('Factory'));
  });
}
