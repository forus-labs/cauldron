import Flutter
import UIKit

class HapticChannel {
  
  private let methodHander = HapticMethodHandler()
  private let methodChannel: FlutterMethodChannel
  
  init(with registrar: FlutterPluginRegistrar) {
    methodChannel = FlutterMethodChannel(name: "com.foruslabs.stevia.haptic", binaryMessenger: registrar.messenger())
    methodChannel.setMethodCallHandler(methodHander.handle)
  }
  
}

class HapticMethodHandler {
  
  private let feedback = HapticFeedback()
  
  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch (call.method, call.arguments) {
    case ("hapticFeedback", let pattern as String):
      result(feedback.perform(pattern))
    case ("hapticFeedback", _):
      result(FlutterError(code: HapticFeedback.code, message: "No pattern was specified", details: nil));
      
    default:
      result(FlutterMethodNotImplemented)
    }
  }
  
}

class HapticFeedback {
  static let code = "invalid-haptic-pattern"
  
  private let notificationFeedback = UINotificationFeedbackGenerator()
  private let selectionFeedback = UISelectionFeedbackGenerator()
  private let heavyImpactFeedback = UIImpactFeedbackGenerator(style: .heavy)
  private let mediumImpactFeedback = UIImpactFeedbackGenerator(style: .medium)
  private let lightImpactFeedback = UIImpactFeedbackGenerator(style: .light)
  private var rigitImpactFeedback: UIImpactFeedbackGenerator?
  private var softImpactFeedback: UIImpactFeedbackGenerator?
  
  init() {
    if #available(iOS 13, *) {
      rigitImpactFeedback = UIImpactFeedbackGenerator(style: .rigid)
      softImpactFeedback = UIImpactFeedbackGenerator(style: .soft)
    }
  }
  
  func perform(_ pattern: String) -> Any? {
    switch pattern {
    case "success": notificationFeedback.notificationOccurred(.success)
    case "warning": notificationFeedback.notificationOccurred(.warning)
    case "error": notificationFeedback.notificationOccurred(.error)
    case "selection": selectionFeedback.selectionChanged()
    case "heavy": heavyImpactFeedback.impactOccurred()
    case "medium": mediumImpactFeedback.impactOccurred()
    case "light": lightImpactFeedback.impactOccurred()
    case "rigid": rigitImpactFeedback?.impactOccurred()
    case "soft": softImpactFeedback?.impactOccurred()
    default:
      return FlutterError(code: HapticFeedback.code, message: "Unsupported pattern: \(pattern)", details: nil)
    }
    
    return nil
  }
}
