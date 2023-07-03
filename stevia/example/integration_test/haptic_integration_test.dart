@Timeout(const Duration(minutes: 30))
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:stevia/stevia.dart';

void main() {
  setUpAll(() => IntegrationTestWidgetsFlutterBinding.ensureInitialized());

  for (final function in [
    Haptic.success,
    Haptic.warning,
    Haptic.failure,
    Haptic.heavy,
    Haptic.medium,
    Haptic.light,
    () async => Haptic.perform((null, IOSHapticPattern.warning)),
  ]) {
    testWidgets(
      'Haptic returns normally',
      (tester) async => expect(() async => function(), returnsNormally),
    );
  }

}
