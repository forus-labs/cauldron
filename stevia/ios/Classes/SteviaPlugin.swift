import Flutter
import UIKit

public class SteviaPlugin: NSObject, FlutterPlugin {
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    registrar.addApplicationDelegate(SteviaPlugin(with: registrar))
  }
  
  
  private let hapticChannel: HapticChannel
  private let timezoneChannel: TimezoneChannel
  
  init(with registrar: FlutterPluginRegistrar) {
    hapticChannel = HapticChannel(with: registrar)
    timezoneChannel = TimezoneChannel(with: registrar)
  }

}

