import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sugar/sugar.dart';

import 'package:stevia/src/services/haptic/haptic_pattern.dart';

/// A [PlatformHaptic] that delegates performing haptic feedback to the native platform.
@internal class PlatformHaptic extends PlatformInterface {

  static final Object _token = Object();

  /// Creates a [PlatformHaptic] for the current platform.
  factory PlatformHaptic.platform() => switch (const Runtime().type) {
    PlatformType.android => AndroidHaptic(),
    PlatformType.ios => IOSHaptic(),
    _ => PlatformHaptic(),
  };

  /// Creates a [PlatformHaptic].
  PlatformHaptic(): super(token: _token);

  /// Performs the haptic feedback [pattern].
  ///
  /// Returns `true` if the haptic feedback was successfully performed.
  Future<void> perform((AndroidHapticPattern?, IOSHapticPattern?) pattern) async {}

  /// The channel.
  MethodChannel get channel => const MethodChannel('com.foruslabs.stevia.haptic');

}

/// A stub [PlatformHaptic] that does nothing.
@internal class StubHaptic extends PlatformHaptic {

  /// The calls to [perform].
  final List<(AndroidHapticPattern?, IOSHapticPattern?)> calls = [];

  /// Creates a [StubHaptic] for testing.
  StubHaptic();

  @override
  Future<void> perform((AndroidHapticPattern?, IOSHapticPattern?) pattern) async => calls.add(pattern);

}

/// A [PlatformHaptic] for Android devices.
@internal final class AndroidHaptic extends PlatformHaptic {
  @override
  Future<void> perform((AndroidHapticPattern?, IOSHapticPattern?) pattern) async {
    final (android, _) = pattern;
    if (android != null) {
      await channel.invokeMethod<void>('hapticFeedback', android.name);
    }
  }
}

/// A [PlatformHaptic] for iOS devices.
@internal final class IOSHaptic extends PlatformHaptic {
  @override
  Future<void> perform((AndroidHapticPattern?, IOSHapticPattern?) pattern) async {
    final (_, ios) = pattern;
    if (ios != null) {
      await channel.invokeMethod<void>('hapticFeedback', ios.name);
    }
  }
}
