//
//  ContentView.swift
//  Expenses
//
//  Created by Santi Ochoa on 2/3/25.
//

import SwiftUI
import SwiftData
import Combine
import WidgetKit

struct ContentView: View {
  
  @StateObject private var securityManager = SecurityManager.shared
  
  @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
  @AppStorage("isLockEnabled") var isLockEnabled: Bool = true
  @AppStorage("lockWhenAppIsInBackground") var lockWhenAppIsInBackground: Bool = true
  @AppStorage("lockPin") var lockPin: String = "1234"

  @Environment(\.scenePhase) var phase
  
  @State private var isUnlocked = false
  @State var valueBefore: ScenePhase = .background
  
  var lockType: LockType = .both
  
  var body: some View {
    LockView(lockType: lockType, lockPin: lockPin, isEnabled: isLockEnabled, isUnlocked: $isUnlocked) {
      TabView {
        Tab("Recents", systemImage: "calendar") {
          RecentsView()
        }
        
        Tab("Search", systemImage: "magnifyingglass") {
          SearchView()
        }
        
        Tab("Chart", systemImage: "chart.bar") {
          ChartTabView()
        }
        
        Tab("Settings", systemImage: "gear") {
          SettingsView()
        }
      }
      .sheet(isPresented: $isFirstLaunch) {
        IntroScreen()
      }
    }
    // Doesn't work if I put it inside of the LockView, so I have to pass isUnlocked as a binding
    .onChange(of: phase) { oldValue, newValue in
      print(oldValue, newValue)
      
      // The app is not active
      if newValue != .active {
        
        // Refresh all widgets
        WidgetCenter.shared.reloadAllTimelines()
        
        // Lock the screen if it is enabled
        if lockWhenAppIsInBackground {
          isUnlocked = false
          valueBefore = oldValue
          return
        }
      }
      
      guard securityManager.automaticallyScanFaceID else { return }
      guard isLockEnabled && !isUnlocked else { return }
      // App comes from the background to active
      let wasInBackground: Bool = oldValue == .inactive && newValue == .active && valueBefore == .background
      
      let canUseBiometrics = lockType == .both && !securityManager.noBiometricAccess
      let isLockTypeBiometricOnly = lockType == .biometric
      
      if wasInBackground && (canUseBiometrics || isLockTypeBiometricOnly) {
        securityManager.unlockView(lockType: lockType) {
          isUnlocked = true
        }
      }
      
      valueBefore = oldValue
    }
  }
}

#Preview {
  ContentView()
    .modelContainer(for: Transaction.self, inMemory: true)
}

