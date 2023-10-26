import 'package:flutter_test/flutter_test.dart';
import 'package:stevia/services_haptic.dart';
import 'package:stevia/src/services/haptic/platform_haptic.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('StubHaptic', () {
    final StubHaptic platform = StubHaptic();

    test('perform(...)', () async {
      await platform.perform((AndroidHapticPattern.confirm, IOSHapticPattern.success));
      expect(platform.calls.single, (AndroidHapticPattern.confirm, IOSHapticPattern.success));
    });
  });

  group('AndroidHaptic', () {
    final PlatformHaptic platform = AndroidHaptic();

    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        platform.channel,
        (call) async => switch (call.arguments) {
          final String pattern when AndroidHapticPattern.values.any((e) => e.name == pattern) => null,
          _ => throw AssertionError('invalid pattern'),
        }
      );
    });

    for (final pattern in AndroidHapticPattern.values) {
      test('perform(...)', () async => expect(() async => platform.perform((pattern, IOSHapticPattern.success)), returnsNormally));
    }

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(platform.channel, null);
    });
  });

  group('IOSHaptic', () {
    final PlatformHaptic platform = IOSHaptic();

    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
          platform.channel,
              (call) async => switch (call.arguments) {
            final String pattern when IOSHapticPattern.values.any((e) => e.name == pattern) => null,
            _ => throw AssertionError('invalid pattern'),
          }
      );
    });

    for (final pattern in IOSHapticPattern.values) {
      test('perform(...)', () async => expect(() async => platform.perform((AndroidHapticPattern.confirm, pattern)), returnsNormally));
    }

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(platform.channel, null);
    });
  });

}
