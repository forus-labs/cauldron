import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stevia/src/time/platform_timezone.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PlatformTimezone', () {
    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
          PlatformTimezone.channel,
              (call) async => switch (call.arguments) {
            null => 'Europe/London',
            _ => throw AssertionError('invalid argument'),
          }
      );
    });

    test('initial timezone is set', () async {
      final timezone = await PlatformTimezone.of();
      expect(timezone.current, 'Europe/London');
    });

    test('updated timezone is set', () async {
      final timezone = await PlatformTimezone.of();
      expect(timezone.current, 'Europe/London');

      await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.handlePlatformMessage(
        'com.foruslabs.stevia.time.changes',
        const StandardMethodCodec().encodeSuccessEnvelope('America/Detroit'),
            (data) { },
      );

      expect(timezone.current, 'America/Detroit');
    });
  });
}
