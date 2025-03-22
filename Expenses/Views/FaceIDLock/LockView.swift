//
//  LockView.swift
//  Expenses
//
//  Created by Santi Ochoa on 2/6/25.
//
import SwiftUI

struct LockView<Content : View>: View {
  
  @StateObject var securityManager = SecurityManager.shared
  
  var lockType: LockType
  var lockPin: String
  var isEnabled: Bool
  
  // To lock the app when it goes in the background
  @Binding var isUnlocked: Bool
  
  @ViewBuilder var content: Content
  
  var body: some View {
    GeometryReader { geometry in
      let size = geometry.size
      
      content
        .frame(width: size.width, height: size.height)
        .animation(.easeInOut, value: isUnlocked)
      
      // Animation purpose, not sure why it doesn't animate without this
      Rectangle()
        .fill(.background)
        .ignoresSafeArea()
        .opacity(!isEnabled || isUnlocked ? 0 : 1)
      
      if isEnabled && !isUnlocked {
        
        ZStack {
          
          Rectangle()
            .fill(.background)
            .ignoresSafeArea()
          
          if (lockType == .both && !securityManager.noBiometricAccess) || lockType == .biometric {
            FaceIDView()
          } else {
            NumberPadView()
          }
        }
        .transition(.opacity)
        .onChange(of: isEnabled) { oldValue, newValue in
          if newValue {
            unlockView()
          }
        }
      }
    }
    .animation(.easeInOut, value: isUnlocked)

  }
  
  @ViewBuilder
  func FaceIDView() -> some View {
    Group {
      if securityManager.noBiometricAccess {
        
        // Face ID is not enabled
        ContentUnavailableView {
          Label("Face ID is not enabled", systemImage: "faceid")
            .imageScale(.large)
            .padding(.bottom, 5)
        } description: {
          Text("In order to use Face ID authentication, please enable it in your device settings")
        } actions: {
          Button("Open Settings") {
            UIApplication.shared.open(
              URL(string: UIApplication.openSettingsURLString)!
            )
          }
        }
        
      } else {
        // Face ID view
        ZStack {
          Rectangle()
            .fill(.background)
            .ignoresSafeArea()
          
          ContentUnavailableView {
            Label("App is locked", systemImage: "lock.fill")
              .padding()
              .imageScale(.large)
          } description: {
            Text("Please unlock using biometric authentication to access the app")
          }
          .vSpacing()
          .offset(y: -50)
          
          VStack {
            let height: CGFloat = 50
            let width: CGFloat = 330
            
            Button(action: unlockView){
              Label("Unlock with FaceID", systemImage: "faceid")
                .font(.title3)
                .bold()
                .foregroundColor(.white)
                .frame(width: width, height: height)
                .background(.blue)
                .clipShape(.rect(cornerRadius: 10))
                .padding(.bottom, 5)
            }
            .buttonStyle(.scaled)
            
            if lockType == .both {
              Button {
                withAnimation {
                  securityManager.noBiometricAccess = true
                }
              } label: {
                Text("Use pin instead")
                  .font(.callout)
              }
              .buttonStyle(.scaled)
              .padding(.top, 5)
              .padding(.bottom, 20)
            }
          }
          .vSpacing(.bottom)
        }
      }
    }
  }
  
  @ViewBuilder
  func NumberPadView() -> some View {
    VStack(spacing: 15) {
      Text("Enter Pin")
        .font(.title)
        .bold()
        .hSpacing()
        .padding(.top, 30)
      
      TextFieldView(value: $securityManager.pin) { currentValue in
        securityManager.checkPinCodeState(lockPin, currentValue: currentValue) {
          isUnlocked = true
        }
      }
      .vSpacing(.bottom)
      .padding(.bottom, 80)
      
      GeometryReader { _ in
        LazyVGrid(columns: Array(repeating: GridItem(), count: 3)) {
          ForEach(1...9, id: \.self) { num in
            Button {
              if securityManager.pin.count < 4 {
                securityManager.pin.append("\(num)")
              }
              playHaptic()
            } label: {
              Text("\(num)")
                .font(.title)
                .hSpacing()
                .padding(.vertical, 20)
                .contentShape(.rect)
            }
            .buttonStyle(.scaled)
          }
          
          Group {
            if lockType == .both && securityManager.isBioMetricAvailable {
              Button {
                withAnimation {
                  securityManager.pin = ""
                  securityManager.noBiometricAccess = false
                  unlockView()
                }
              } label: {
                Image(systemName: "faceid")
                  .font(.title)
                  .hSpacing()
                  .padding(.vertical, 20)
                  .contentShape(.rect)
              }
              .tint(.primary)
              .buttonStyle(.scaled)

            } else {
              Color.clear
            }
          }
          
          Button {
            if securityManager.pin.count < 4 {
              securityManager.pin.append("0")
            }
            playHaptic()
          } label: {
            Text("0")
              .font(.title)
              .hSpacing()
              .padding(.vertical, 20)
              .contentShape(.rect)
          }
          .buttonStyle(.scaled)
          
          Button {
            if !securityManager.pin.isEmpty {
              securityManager.pin.removeLast()
            }
            playHaptic()
          } label: {
            Image(systemName: "delete.backward")
              .font(.title)
              .hSpacing()
              .padding(.vertical, 20)
              .contentShape(.rect)
          }
          .buttonStyle(.scaled)
          .opacity(securityManager.pin.isEmpty ? 0 : 1)
        }
        .vSpacing(.bottom)
      }
      .buttonStyle(.plain)
    }
    .bold()
    .padding()
    .animation(.snappy(duration: 0.3), value: securityManager.pin)
  }
  
  private func unlockView() {
    securityManager.unlockView(lockType: lockType) {
      isUnlocked = true
    }
  }
  
  private func playHaptic() {
    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
  }
}

enum LockType: String, CaseIterable {
  case biometric
  case number
  case both
  
  var description: String {
    switch self {
    case .biometric:
      return "Biometric Authentication"
    case .number:
      return "Number Authentication"
    case .both:
      return "Biometric and Number Authentication" 
    }
  }
}

#Preview {
  //  LockView(lockType: .both, lockPin: "1234", isEnabled: true, isUnlocked: .constant(false)){
  ContentView()
  //  }
}
