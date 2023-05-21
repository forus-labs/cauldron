import 'package:flutter/services.dart';

// ignore_for_file: public_member_api_docs

/// Platform-agnostic haptic feedback patterns.
enum HapticPattern {

  success((AndroidHapticPattern.confirm, IOSHapticPattern.success)),
  warning((AndroidHapticPattern.clockTick, IOSHapticPattern.warning)),
  failure((AndroidHapticPattern.reject, IOSHapticPattern.error)),

  /// The equivalent of [HapticFeedback.heavyImpact].
  heavy((AndroidHapticPattern.contextClick, IOSHapticPattern.heavy)),

  /// The equivalent of [HapticFeedback.mediumImpact].
  medium((AndroidHapticPattern.keyboardTap, IOSHapticPattern.medium)),

  /// The equivalent of [HapticFeedback.lightImpact].
  light((AndroidHapticPattern.virtualKey, IOSHapticPattern.light));

  /// The native feedback types the various platforms.
  final (AndroidHapticPattern, IOSHapticPattern) value;

  const HapticPattern(this.value);

}

/// The pre-defined haptic feedback patterns on Android.
///
/// See [HapticFeedbackConstants](https://developer.android.com/reference/android/view/HapticFeedbackConstants).
///
/// ## Caveats
/// Certain haptic feedback patterns require higher Android API levels than the minimum version of `26`. Those functions
/// have no effect when called on devices below the required API versions.
///
/// Even if a Android device does support the required Android API level, support for haptic feedback patterns is still
/// subject to the manufacturer. For example, the Redmi Note 9S supports most patterns except for [reject] and [contextClick].
///
/// TL;DR: Haptic feedback on Android devices is a mess.
enum AndroidHapticPattern {
  clockTick('CLOCK_TICK', 21),
  confirm('CONFIRM', 30),
  contextClick('CONTEXT_CLICK', 23),
  gestureStart('GESTURE_START', 30),
  gestureEnd('GESTURE_END', 30),
  keyboardPress('KEYBOARD_PRESS', 27),
  keyboardRelease('KEYBOARD_RELEASE', 27),
  keyboardTap('KEYBOARD_TAP', 8),
  longPress('LONG_PRESS', 3),
  reject('REJECT', 30),
  textHandleMove('TEXT_HANDLE_MOVE', 27),
  virtualKey('VIRTUAL_KEY', 5),
  virtualKeyRelease('VIRTUAL_KEY_RELEASE', 27);

  /// The haptic feedback pattern name.
  final String name;
  /// The minimum required Android API level.
  final int level;

  const AndroidHapticPattern(this.name, this.level);
}

/// The pre-defined haptic feedback patterns on iOS.
///
/// See [UIFeedbackGenerator](https://developer.apple.com/documentation/uikit/uifeedbackgenerator).
enum IOSHapticPattern {
  success('success', 'UINotificationFeedbackGenerator'),
  warning('warning', 'UINotificationFeedbackGenerator'),
  error('error', 'UINotificationFeedbackGenerator'),

  heavy('heavy', 'UIImpactFeedbackGenerator'),
  medium('medium', 'UIImpactFeedbackGenerator'),
  light('light', 'UIImpactFeedbackGenerator'),
  rigid('rigid', 'UIImpactFeedbackGenerator'),
  soft('soft', 'UIImpactFeedbackGenerator'),

  selection('selection', 'UISelectionFeedbackGenerator');

  /// The haptic feedback pattern name.
  final String name;
  /// The haptic feedback pattern type.
  final String type;

  const IOSHapticPattern(this.name, this.type);
}
