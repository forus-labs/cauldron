import Flutter
import UIKit

public class HapticPlugin: NSObject, FlutterPlugin {
  static let errorCode = "invalid-haptic-pattern"
  
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
      result(FlutterError(code: HapticPlugin.errorCode, message: "No pattern was specified", details: nil));
    default:
      result(FlutterMethodNotImplemented)
    }
  }

}

struct HapticFeedback {
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
    case "success":
      notificationFeedback.notificationOccurred(.success)
      return true
    case "warning":
      notificationFeedback.notificationOccurred(.warning)
      return true
    case "error":
      notificationFeedback.notificationOccurred(.error)
      return true
    case "selection":
      selectionFeedback.selectionChanged()
      return true
    case "heavy":
      heavyImpactFeedback.impactOccurred()
      return true
    case "medium":
      mediumImpactFeedback.impactOccurred()
      return true
    case "light":
      lightImpactFeedback.impactOccurred()
      return true
    case "rigid":
      rigitImpactFeedback?.impactOccurred()
      return rigitImpactFeedback != nil
    case "soft":
      softImpactFeedback?.impactOccurred()
      return softImpactFeedback != nil
      
    default:
      return FlutterError(code: HapticPlugin.errorCode, message: "Unsupported pattern: \(pattern)", details: nil)
    }
  }
}
