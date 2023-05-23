import 'package:flutter_test/flutter_test.dart';
import 'package:stevia/stevia.dart';

void main() {

  for (final function in [
    Haptic.success,
    Haptic.warning,
    Haptic.failure,
    Haptic.heavy,
    Haptic.medium,
    Haptic.light,
    () async => Haptic.perform(HapticPattern.light.value)
  ]) {
    test('function does nothing', () async => expect(() async => function(), returnsNormally));
  }
  
  group('stubForTesting()', () {
    late List<(AndroidHapticPattern?, IOSHapticPattern?)> calls;
    
    setUp(() => calls = Haptic.stubForTesting());
    
    for (final function in [
      Haptic.success,
      Haptic.warning,
      Haptic.failure,
      Haptic.heavy,
      Haptic.medium,
      Haptic.light,
      () async => Haptic.perform(HapticPattern.light.value)
    ]) {
      test('stubbed function does nothing', () async {
        expect(() async => function(), returnsNormally);
        expect(calls.length, 1);
      });
    }
  });

}
