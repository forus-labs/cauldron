import Flutter
import UIKit

public class SteviaPlugin: NSObject, FlutterPlugin {
  static let hapticErrorCode = "invalid-haptic-pattern"
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.foruslabs.stevia.haptic", binaryMessenger: registrar.messenger())
    let instance = HapticPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
  
  
  private let feedback = HapticFeedback()

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch (call.method, call.arguments) {
    case ("hapticFeedback", let pattern as String):
      result(feedback.perform(pattern))
    case ("hapticFeedback", _):
      result(FlutterError(code: SteviaPlugin.hapticErrorCode, message: "No pattern was specified", details: nil));
    default:
      result(FlutterMethodNotImplemented)
    }
  }

}

class HapticFeedback {
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
      return FlutterError(code: SteviaPlugin.hapticErrorCode, message: "Unsupported pattern: \(pattern)", details: nil)
    }
    
    return nil
  }
}
