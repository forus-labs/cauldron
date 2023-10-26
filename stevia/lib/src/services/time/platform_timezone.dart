import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// A [PlatformTimezone] that fetches the platform's current timezone.
@internal class PlatformTimezone extends PlatformInterface {

  /// The channel used to retrieve the current timezone.
  static const MethodChannel channel = MethodChannel('com.foruslabs.stevia.time.current');
  /// The channel used to listen for changes to the current timezone.
  static const EventChannel events = EventChannel('com.foruslabs.stevia.time.changes');
  static final Object _token = Object();

  /// Creates a [PlatformTimezone].
  static Future<PlatformTimezone> of() async {
    // We don't need to cancel the stream subscription since it spans the lifetime of an application.
    final timezone = await channel.invokeMethod<String>('currentTimezone') ?? 'Factory';
    final platform = PlatformTimezone._(timezone);
    events.receiveBroadcastStream().listen((timezone) => platform.current = timezone);

    return platform;
  }

  /// The platform's current timezone.
  String current;

  PlatformTimezone._(this.current): super(token: _token);

}
