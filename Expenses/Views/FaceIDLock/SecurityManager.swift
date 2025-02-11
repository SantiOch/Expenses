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
  
  // Variable para evitar intentos infinitos tras un fallo
//  @Published var isFaceIDLocked: Bool = false
  
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
//            isFaceIDLocked = false // Restablecer el bloqueo tras éxito
          }
        } catch {
          print("Face ID failed: \(error.localizedDescription)")
//          isFaceIDLocked = true // Bloqueamos intentos inmediatos tras un fallo
          
          // Permitir un nuevo intento después de un retraso
//          DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.isFaceIDLocked = false
//          }
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
