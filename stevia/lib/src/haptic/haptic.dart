import 'package:meta/meta.dart';
import 'package:stevia/haptic.dart';
import 'package:stevia/src/haptic/platform_haptic.dart';
import 'package:sugar/sugar.dart';
import 'package:flutter/services.dart';

/// Provides functions for performing haptic feedback on devices.
///
/// ## Testing
/// In tests, you can replace [Haptic] with a stub implementation using [stubForTesting]. It is recommended to always call
/// [stubForTesting] inside `setUp(...)`. Not doing so leads to the stub being reused across tests. This may affect the
/// result of the tests.
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
/// ```
///
/// ## Android Caveats
/// Certain haptic feedback patterns require higher Android API levels than the minimum version of `26`. Those functions
/// have no effect when called on devices below the required API versions.
///
/// Even if a Android device does support the required Android API level, support for haptic feedback patterns is still
/// subject to the manufacturer. For example, the Redmi Note 9S supports most patterns except for [failure] and [heavy].
///
/// TL;DR: Haptic feedback on Android devices is a mess.
extension Haptic on Never {

  /// Stubs [Haptic]'s functions for testing.
  ///
  /// Returns the calls with the given arguments to [Haptic].
  ///
  /// It is recommended to always call [stubForTesting] inside `setUp(...)`. Not doing so leads to the stub being reused
  /// across tests. This may affect the result of the tests.
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
  ///     expect(calls.single, HapticPattern.success.value);
  ///   });
  ///
  ///   test('nothing', () {
  ///     expect(calls.isEmpty, 0);
  ///   });
  /// }
  @visibleForTesting
  @Possible({AssertionError})
  static List<(AndroidHapticPattern?, IOSHapticPattern?)> stubForTesting() {
    var assertionsEnabled = false;
    assert(() {
      assertionsEnabled = true;
      return true;
    }(), '');

    if (!assertionsEnabled) {
      throw AssertionError('`Haptic.stubForTesting()` is not intended for use in release builds.');
    }

    final platform = StubHaptic();
    _platform = platform;

    return platform.calls;
  }

  static PlatformHaptic _platform = PlatformHaptic.platform();


  /// Performs a haptic feedback that indicates a task has completed successfully.
  static Future<void> success() => perform(HapticPattern.success.value);

  /// Performs a haptic feedback that indicates a task has produced a warning.
  static Future<void> warning() => perform(HapticPattern.warning.value);

  /// Performs a haptic feedback that indicates a task has failed.
  static Future<void> failure() => perform(HapticPattern.failure.value);


  /// Performs a haptic feedback that correspond to a collision between large, heavy user interface elements.
  ///
  /// This is the equivalent of [HapticFeedback.heavyImpact].
  static Future<void> heavy() => perform(HapticPattern.heavy.value);

  /// Performs a haptic feedback that correspond to a collision between moderately sized user interface elements.
  ///
  /// This is the equivalent of [HapticFeedback.mediumImpact].
  static Future<void> medium() => perform(HapticPattern.medium.value);

  /// Performs a haptic feedback that correspond to a collision between small, light user interface elements.
  ///
  /// This is the equivalent of [HapticFeedback.lightImpact].
  static Future<void> light() => perform(HapticPattern.light.value);


  /// Performs the haptic feedback [pattern].
  ///
  /// No haptic feedback is performed on the specific platform if the pattern is null.
  ///
  /// ```dart
  /// // Performs 'confirm' on Android and 'success' on iOS.
  /// Haptic.feedback((AndroidHapticPattern.confirm, IOSHapticPattern.success));
  ///
  /// // Does nothing on Android and performs 'success' on iOS.
  /// Haptic.feedback((null, IOSHapticPattern.success));
  /// ```
  static Future<void> perform((AndroidHapticPattern?, IOSHapticPattern?) pattern) => _platform.perform(pattern);

}
