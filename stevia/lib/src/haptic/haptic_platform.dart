import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sugar/sugar.dart';

import 'package:stevia/src/haptic/haptic_pattern.dart';

/// A [PlatformHaptic] that delegates performing haptic feedback to the native platform.
@internal sealed class PlatformHaptic extends PlatformInterface {

  static final Object _token = Object();

  final MethodChannel _channel;

  /// Creates a [PlatformHaptic] for the current platform.
  factory PlatformHaptic() => switch (const Runtime().type) {
    PlatformType.android => AndroidPlatformHaptic(),
    PlatformType.ios => IOSPlatformHaptic(),
    _ => NoopPlatformHaptic(),
  };

  PlatformHaptic._(): _channel = const MethodChannel('com.foruslabs.stevia.haptic'), super(token: _token);

  /// Performs the haptic feedback of the given [type].
  ///
  /// Returns `true` if the haptic feedback was successfully performed.
  Future<bool> feedback((AndroidHapticPattern?, IOSHapticPattern?) pattern);

}

/// A [PlatformHaptic] for Android devices.
@internal final class AndroidPlatformHaptic extends PlatformHaptic {

  /// Creates a [PlatformHaptic] for Android devices.
  AndroidPlatformHaptic(): super._();

  @override
  Future<bool> feedback((AndroidHapticPattern?, IOSHapticPattern?) pattern) async {
    final (android, _) = pattern;
    if (android == null) {
      return false;
    }

    return await _channel.invokeMethod<bool>('hapticFeedback', android.name) ?? false;
  }

}

/// A [PlatformHaptic] for iOS devices.
@internal final class IOSPlatformHaptic extends PlatformHaptic {

  /// Creates a [PlatformHaptic] for iOS devices.
  IOSPlatformHaptic(): super._();

  @override
  Future<bool> feedback((AndroidHapticPattern?, IOSHapticPattern?) pattern) async {
    final (_, ios) = pattern;
    if (ios == null) {
      return false;
    }

    return await _channel.invokeMethod<bool>('hapticFeedback', ios.name) ?? false;
  }

}

/// A [PlatformHaptic] that does not do anything.
@internal final class NoopPlatformHaptic extends PlatformHaptic {

  final bool _success;

  /// Creates a [NoopPlatformHaptic].
  NoopPlatformHaptic({bool success = true}): _success = success, super._();

  @override
  Future<bool> feedback((AndroidHapticPattern?, IOSHapticPattern?) pattern) async => _success;

}

