//
//  SettingsView.swift
//  Expenses
//
//  Created by Santi Ochoa on 2/7/25.
//
import SwiftUI

struct SettingsView: View {
  
  @StateObject var settingsManager = SettingsManager.shared
  
  var body: some View {
    NavigationStack {
      Form {
        Section {
          TextField("UserName", text: $settingsManager.userName)
        } header: {
          Text("User settings")
        } footer: {
          Text("Change user settings here, like username, password, etc.")
        }
        
        Section {
          Toggle("Enable app lock", isOn: $settingsManager.isLockEnabled)
          if settingsManager.isLockEnabled {
            Toggle("Lock when app is in background", isOn: $settingsManager.lockWhenAppIsInBackground)
            Toggle("Automatically scan Face ID", isOn: $settingsManager.automaticallyScanFaceID)
          }
          
          SecureField("App Lock Pin", text: $settingsManager.lockPin)
            
          
        } header: {
          Text("Security")
        } footer: {
          Text("Enable or disable the app lock, so that only users with a valid passcode or Face ID can unlock the app, change if the app should be locked when it is in the background, and change if the app should automatically scan for Face ID when it becomes active, or not.")
        }
        
        Section("First launch") {
          Toggle("First launch", isOn: $settingsManager.isFirstLaunch)
        }
      }
      .navigationTitle("Settings")
      .animation(.easeIn, value: settingsManager.isLockEnabled)
    }
  }
}

class SettingsManager: ObservableObject {
  
  static let shared = SettingsManager()
  
  private init() { }
  
  // UserName Options
  @AppStorage("userName") var userName: String = "Santi"
  
  // Security Options
  @AppStorage("isLockEnabled") var isLockEnabled: Bool = true
  @AppStorage("lockWhenAppIsInBackground") var lockWhenAppIsInBackground: Bool = true
  @AppStorage("automaticallyScanFaceID") var automaticallyScanFaceID: Bool = true
  @AppStorage("lockPin") var lockPin: String = "1234"

  // First Launch Options
  @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
}
