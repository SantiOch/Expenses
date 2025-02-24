//
//  SecurityManager.swift
//  Expenses
//
//  Created by Santi Ochoa on 2/7/25.
//
import SwiftUI
import LocalAuthentication

@MainActor
class SecurityManager: ObservableObject {
  
  static let shared = SecurityManager()
  
  private init() { }
  
  @Published var pin: String = ""
  @Published var noBiometricAccess: Bool = false
  
  @AppStorage("automaticallyScanFaceID") var automaticallyScanFaceID: Bool = true
  
  let context = LAContext()
  
  var isBioMetricAvailable: Bool {
    return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
  }
  
  public func unlockView(lockType: LockType, onUnlock: @escaping () -> ()) {
 
    guard lockType != .number else { return }
    
    let context = LAContext()
    
    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
      Task {
        do {
          let result = try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                                        localizedReason: "Unlock the App")
          if result {
            print("Unlocked")
            withAnimation(.easeInOut(duration: 0.5)) {
              onUnlock()
            } completion: { [self] in
              pin = ""
            }
          }
        } catch {
          print("Face ID failed: \(error.localizedDescription)")
        }
      }
    } else {
      noBiometricAccess = true
    }
  }
  
  public func checkPinCodeState(_ lockPin: String, currentValue: String, onUnlock: @escaping () -> ()) -> TypingState {
    if currentValue.count == 4 {
      if lockPin == currentValue {
        Task { @MainActor in
          try? await Task.sleep(for: .seconds(0.3))
          playHaptic(type: .success)
          try? await Task.sleep(for: .seconds(0.8))
          withAnimation(.easeInOut(duration: 0.5)) {
            onUnlock()
          }
          pin = ""
        }
        return .correct
      } else {
        Task {
          try? await Task.sleep(for: .seconds(0.1))
          playHaptic(type: .error)
          try? await Task.sleep(for: .seconds(0.5))
          pin = ""
        }
        return .incorrect
      }
    }
    return .typing
  }
  
  private func playHaptic(type: UINotificationFeedbackGenerator.FeedbackType) {
    UINotificationFeedbackGenerator().notificationOccurred(type)
  }
}
