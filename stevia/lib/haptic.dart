/// {@category Core}
///
/// Utilities for performing haptic feedback on devices.
///
/// To perform a pre-defined, platform-agnostic haptic feedback, call one of the functions in [Haptic]:
/// ```dart
/// Haptic.success();
/// ```
///
/// You can also perform a custom combination of patterns across platforms using [Haptic.perform].
/// ```dart
/// // Performs 'confirm' on Android and 'success' on iOS.
/// Haptic.feedback((AndroidHapticPattern.confirm, IOSHapticPattern.success));
///
/// // Does nothing on Android and performs 'success' on iOS.
/// Haptic.feedback((null, IOSHapticPattern.success));
/// ```
///
/// ## Testing
/// In tests, you can replace [Haptic] with a stub implementation using [Haptic.stubForTesting]. It is recommended to
/// always call [Haptic.stubForTesting] inside `setUp(...)`. Not doing so leads to the stub being reused across tests.
/// This may affect the result of the tests.
///
/// ```dart
/// class UnderTest {
///   Future<void> foo() async => Haptic.success();
/// }
///
/// void main() {
///   late List<(AndroidHapticPattern?, IOSHapticPattern?)> calls;
///
///   setUp(() => calls = Haptic.stubForTesting());
///
///   test('some test', () async {
///     await UnderTest().foo();
///     expect(calls.length, 1);
///   });
///
///   test('nothing', () {
///     expect(calls.isEmpty, 0);
///   });
/// }
///
/// ## Android Caveats
/// Certain haptic feedback patterns require higher Android API levels than the minimum version of `26`. Those functions
/// have no effect when called on devices below the required API versions.
///
/// Even if a Android device does support the required Android API level, support for haptic feedback patterns is still
/// subject to the manufacturer. For example, the Redmi Note 9S supports most patterns except for [Haptic.failure] and
/// [Haptic.heavy].
///
/// TL;DR: Haptic feedback on Android devices is a mess.
library stevia.haptic;

import 'package:stevia/src/haptic/haptic.dart';

export 'package:stevia/src/haptic/haptic.dart';
export 'package:stevia/src/haptic/haptic_pattern.dart';
