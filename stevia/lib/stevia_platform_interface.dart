import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'stevia_method_channel.dart';

abstract class SteviaPlatform extends PlatformInterface {
  /// Constructs a SteviaPlatform.
  SteviaPlatform() : super(token: _token);

  static final Object _token = Object();

  static SteviaPlatform _instance = MethodChannelStevia();

  /// The default instance of [SteviaPlatform] to use.
  ///
  /// Defaults to [MethodChannelStevia].
  static SteviaPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SteviaPlatform] when
  /// they register themselves.
  static set instance(SteviaPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion(String argument) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
