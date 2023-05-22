import 'dart:collection';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sugar/sugar.dart';

import 'package:stevia/src/haptic/haptic_pattern.dart';

/// A [PlatformHaptic] that delegates performing haptic feedback to the native platform.
class PlatformHaptic extends PlatformInterface {

  static final Object _token = Object();

  final MethodChannel _channel = const MethodChannel('com.foruslabs.stevia.haptic');

  /// Creates a [PlatformHaptic] for the current platform.
  factory PlatformHaptic() => switch (const Runtime().type) {
    PlatformType.android => _AndroidHaptic(),
    PlatformType.ios => _IOSHaptic(),
    _ => PlatformHaptic(),
  };

  PlatformHaptic._(): super(token: _token);

  /// Performs the haptic feedback [pattern].
  ///
  /// Returns `true` if the haptic feedback was successfully performed.
  Future<void> perform((AndroidHapticPattern?, IOSHapticPattern?) pattern) async => false;

}

/// A stub [PlatformHaptic] that does nothing.
@internal class StubHaptic implements PlatformHaptic {

  /// The calls to [perform].
  final List<(AndroidHapticPattern?, IOSHapticPattern?)> calls = [];

  /// Creates a [StubHaptic] for testing.
  StubHaptic();

  @override
  Future<void> perform((AndroidHapticPattern?, IOSHapticPattern?) pattern) async => calls.add(pattern);

  @override
  MethodChannel get _channel => throw UnimplementedError();

}

class _AndroidHaptic extends PlatformHaptic {
  _AndroidHaptic(): super._();

  @override
  Future<void> perform((AndroidHapticPattern?, IOSHapticPattern?) pattern) async {
    final (android, _) = pattern;
    if (android != null) {
      await _channel.invokeMethod<void>('hapticFeedback', android.name);
    }
  }
}


class _IOSHaptic extends PlatformHaptic {
  _IOSHaptic(): super._();

  @override
  Future<void> perform((AndroidHapticPattern?, IOSHapticPattern?) pattern) async {
    final (_, ios) = pattern;
    if (ios != null) {
      await _channel.invokeMethod<void>('hapticFeedback', ios.name);
    }
  }
}
