import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'stevia_platform_interface.dart';

/// An implementation of [SteviaPlatform] that uses method channels.
class MethodChannelStevia extends SteviaPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('stevia');

  @override
  Future<String?> getPlatformVersion(String argument) async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion', argument);
    return version;
  }
}
