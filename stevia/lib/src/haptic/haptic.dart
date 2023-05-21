import 'package:meta/meta.dart';
import 'package:stevia/haptic.dart';
import 'package:stevia/src/haptic/haptic_platform.dart';
import 'package:sugar/sugar.dart';
import 'package:flutter/services.dart';

/// Provides functions for performing haptic feedback on devices.
///
/// ## Testing
/// In tests, you can replace [Haptic] with a stub implementation using [stubForTesting]. The stub implementation does
/// not do anything and always return a specified value.
///
/// ```dart
/// class UnderTest {
///
///   Future<bool>> foo() async => Haptic.success();
///
/// }
///
/// void main() {
///
///   setUp(() => Haptic.stubForTesting(success: false));
///
///   test('some test', () async {
///     expect(await UnderTest().foo(), false); // UnderTest.foo() always returns false
///   });
///
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
  /// The stubbed functions do not do anything. They always return [success].
  @visibleForTesting
  @Possible({AssertionError})
  static void stubForTesting({bool success = true}) {
    var assertionsEnabled = false;
    assert(() {
      assertionsEnabled = true;
      return true;
    }(), '');

    if (!assertionsEnabled) {
      throw AssertionError('`Haptic.stubForTesting` is not intended for use in release builds.');
    }

    _platform = NoopPlatformHaptic(success: success);
  }

  static PlatformHaptic _platform = PlatformHaptic();


  /// Performs a haptic feedback that indicates a task has completed successfully.
  static Future<bool> success() => feedback(HapticPattern.success.value);

  /// Performs a haptic feedback that indicates a task has produced a warning.
  static Future<bool> warning() => feedback(HapticPattern.warning.value);

  /// Performs a haptic feedback that indicates a task has failed.
  static Future<bool> failure() => feedback(HapticPattern.failure.value);


  /// Performs a haptic feedback that correspond to a collision between large, heavy user interface elements.
  ///
  /// This is the equivalent of [HapticFeedback.heavyImpact].
  static Future<bool> heavy() => feedback(HapticPattern.heavy.value);

  /// Performs a haptic feedback that correspond to a collision between moderately sized user interface elements.
  ///
  /// This is the equivalent of [HapticFeedback.mediumImpact].
  static Future<bool> medium() => feedback(HapticPattern.medium.value);

  /// Performs a haptic feedback that correspond to a collision between small, light user interface elements.
  ///
  /// This is the equivalent of [HapticFeedback.lightImpact].
  static Future<bool> light() => feedback(HapticPattern.light.value);


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
  static Future<bool> feedback((AndroidHapticPattern?, IOSHapticPattern?) pattern) => _platform.feedback(pattern);

}
