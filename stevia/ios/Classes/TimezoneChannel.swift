//
//  Timezone.swift
//  stevia
//
//  Created by Matthias Ngeo on 24/6/23.
//

import Foundation
import Flutter

class TimezoneChannel {
  
  private let streamHandler = TimezoneStreamHandler()
  private let methodChannel: FlutterMethodChannel
  private let streamChannel: FlutterEventChannel
  
  init(with registrar: FlutterPluginRegistrar) {
    methodChannel = FlutterMethodChannel(name: "com.foruslabs.stevia.time.current", binaryMessenger: registrar.messenger())
    methodChannel.setMethodCallHandler(timezoneMethodHandler)
    streamChannel = FlutterEventChannel(name: "com.foruslabs.stevia.time.changes", binaryMessenger: registrar.messenger())
    streamChannel.setStreamHandler(streamHandler)
  }
  
}
  
func timezoneMethodHandler(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
  switch (call.method, call.arguments) {
  case ("currentTimezone", nil):
    result(TimeZone.current.identifier)
  case ("currentTimezone", _):
    result(FlutterError(code: "invalid-argument", message: "Unknown argument was passed to currentTimezone", details: nil));
  default:
    result(FlutterMethodNotImplemented)
  }
}

class TimezoneStreamHandler: NSObject, FlutterStreamHandler {

  private var sink: FlutterEventSink?
  
  override init() {
    super.init()
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(handleTimeZoneChange(_:)),
      name: NSNotification.Name.NSSystemTimeZoneDidChange,
      object: nil
    )
  }
  
  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    sink = events
    return nil
  }

  @objc func handleTimeZoneChange(_ notification: Notification) {
    if let sink = sink {
      sink(TimeZone.current.identifier)
    }
  }
  
  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    sink = nil
    return nil
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
}
