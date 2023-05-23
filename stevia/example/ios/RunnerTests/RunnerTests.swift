import Flutter
import UIKit
import XCTest

@testable import stevia



// This demonstrates a simple unit test of the Swift portion of this plugin's implementation.
//
// See https://developer.apple.com/documentation/xctest for more information about using XCTest.

class HapticPluginTests: XCTestCase {
  
  let plugin = HapticPlugin()
  
  func testHandleSuccessful() {
    let call = FlutterMethodCall(methodName: "hapticFeedback", arguments: "success")
    let expectation = expectation(description: "result block must be called.")
    
    plugin.handle(call) { result in
      XCTAssertNil(result)
      expectation.fulfill()
    }
    waitForExpectations(timeout: 1)
  }
  
  func testHandleInvalidArgument() {
    let call = FlutterMethodCall(methodName: "hapticFeedback", arguments: nil)
    let expectation = expectation(description: "result block must be called.")
    
    plugin.handle(call) { result in
      XCTAssertEqual(
        result as! FlutterError,
        FlutterError(code: HapticPlugin.errorCode, message: "No pattern was specified", details: nil)
      )
      expectation.fulfill()
    }
    waitForExpectations(timeout: 1)
  }
  
  func testHandleUnsupportedMethod() {
    let call = FlutterMethodCall(methodName: "invalid", arguments: "success")
    let expectation = expectation(description: "result block must be called.")
    
    plugin.handle(call) { result in
      XCTAssertEqual(
        result as! NSObject,
        FlutterMethodNotImplemented
      )
      expectation.fulfill()
    }
    waitForExpectations(timeout: 1)
  }
  
}

class HapticFeedbackTests: XCTestCase {

  let feedback = HapticFeedback()
  
  func testHapticFeedbackPerformSuccess() {
    XCTAssertNil(feedback.perform("success"))
  }
  
  func testHapticFeedbackPerformWarning() {
    XCTAssertNil(feedback.perform("warning"))
  }
  
  func testHapticFeedbackPerformError() {
    XCTAssertNil(feedback.perform("error"))
  }
  
  func testHapticFeedbackPerformSelection() {
    XCTAssertNil(feedback.perform("selection"))
  }
  
  func testHapticFeedbackPerformHeavy() {
    XCTAssertNil(feedback.perform("heavy"))
  }
  
  func testHapticFeedbackPerformMedium() {
    XCTAssertNil(feedback.perform("medium"))
  }
  
  func testHapticFeedbackPerformLight() {
    XCTAssertNil(feedback.perform("light"))
  }
  
  func testHapticFeedbackPerformRigid() {
    XCTAssertNil(feedback.perform("rigid"))
  }
  
  func testHapticFeedbackPerformSoft() {
    XCTAssertNil(feedback.perform("soft"))
  }
  
  func testHapticFeedbackUnspportedPattern() {
    XCTAssertEqual(
      feedback.perform("invalid") as! FlutterError,
      FlutterError(code: HapticPlugin.errorCode, message: "Unsupported pattern: invalid", details: nil)
    )
  }

}
