//
//  SettingsView.swift
//  Expenses
//
//  Created by Santi Ochoa on 2/7/25.
//
import SwiftUI
import UIKit
import Combine

struct SettingsView: View {
  
  @Environment(\.dismiss) var dismiss
  
  @StateObject var settingsManager = SettingsManager.shared
  
  @FocusState var isFocused: Bool
  
  var body: some View {
    NavigationStack {
      Form {
        Section {
          TextField("UserName", text: $settingsManager.userName)
            .focused($isFocused)
          
        }
        header: {
          Text("User settings")
        }
        footer: {
          Text("Change user settings here, like username, password, etc.")
        }
        
        Section {
          Toggle("Enable app lock", isOn: $settingsManager.isLockEnabled)
          
          if settingsManager.isLockEnabled {
            Toggle("Lock when app is in background", isOn: $settingsManager.lockWhenAppIsInBackground)
            Toggle("Automatically scan Face ID", isOn: $settingsManager.automaticallyScanFaceID)
            SecureField("App Lock Pin", text: $settingsManager.lockPin)
              .keyboardType(.numberPad)
              .onReceive(Just(settingsManager.lockPin)) { _ in
                if settingsManager.lockPin.count > 4 {
                  settingsManager.lockPin = String(settingsManager.lockPin.prefix(4))
                }
              }
              .focused($isFocused)
          }
        }
        header: {
          Text("Security")
        }
        footer: {
          Text("Enable or disable the app lock, so that only users with a valid passcode or Face ID can unlock the app, change if the app should be locked when it is in the background, and change if the app should automatically scan for Face ID when it becomes active, or not.")
        }
        
        Section {
          Picker("Lock Mode Type", selection: $settingsManager.lockType) {
            ForEach(LockType.allCases, id: \.rawValue) { mode in
              Text(mode.rawValue.capitalized).tag(mode)
            }
          }
          .pickerStyle(.navigationLink)
        } footer: {
          Text("For the security unlock options, you can select between this three methods: \n") +
          Text("\(LockModeTypeDescriptionText)")
        }
        
        Section("First launch") {
          Toggle("First launch", isOn: $settingsManager.isFirstLaunch)
        }
      }
      .navigationTitle("Settings")
      .animation(.easeIn, value: settingsManager.isLockEnabled)
      .toolbar {
        ToolbarItem(placement: .keyboard) {
          Button("Done") { isFocused = false }
            .hSpacing(.trailing)
            .bold()
        }
      }
      .toolbarBackground(.thinMaterial, for: .navigationBar)
    }
  }
  
  var LockModeTypeDescriptionText: String {
    var text: String = ""
    
    for mode in LockType.allCases {
      text += "-\(mode.rawValue.capitalized): \(mode.description)\n"
    }
    
    text.removeLast()
    
    return text
  }
}

class SettingsManager: ObservableObject {
  
  static let shared = SettingsManager()
  
  private init() { }
  
  // UserName Options
  @AppStorage("userName") var userName: String = "Santi"
  
  // Security Options
  @AppStorage("isLockEnabled") var isLockEnabled: Bool = false
  @AppStorage("lockWhenAppIsInBackground") var lockWhenAppIsInBackground: Bool = false
  @AppStorage("automaticallyScanFaceID") var automaticallyScanFaceID: Bool = false
  @AppStorage("lockPin") var lockPin: String = "1234"
  @AppStorage("lockType") var lockType: LockType = .both
  
  // First Launch Options
  @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
}

#Preview {
  ContentView()
    .modelContainer(for: Transaction.self)
}
