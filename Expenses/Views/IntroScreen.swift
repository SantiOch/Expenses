//
//  IntroScreen.swift
//  Expenses
//
//  Created by Santi Ochoa on 2/3/25.
//

import SwiftUI

struct IntroScreen : View {
  
  @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
  
  var body: some View {
    VStack {
      Text("What's New in the Expense Tracker")
        .font(.largeTitle)
        .multilineTextAlignment(.center)
        .bold()
        .padding(.top, 50)
        .padding(.bottom, 60)
      
      VStack(alignment: .leading, spacing: 35) {
        PointView(title: "Track your expenses", systemImage: "pencil", description: "Add your expenses with ease", tintColor: .blue)
        PointView(title: "Set budgets", systemImage: "calendar.badge.plus", description: "Create budgets for different categories", tintColor: .red)
        PointView(title: "See your progress", systemImage: "chart.bar.fill", description: "Monitor your spending habits over time", tintColor: .green)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.horizontal, 25)
      
      Spacer()
      
      Button {
        isFirstLaunch = false
      } label: {
        Text("Get started")
          .font(.headline)
          .foregroundColor(.white)
          .frame(height: 50)
          .frame(maxWidth: .infinity, alignment: .center)
          .background(Color.blue)
          .clipShape(.rect(cornerRadius: 10))
          .padding()
        
      }
      .buttonStyle(.scaled)
    }
    .interactiveDismissDisabled()
    .presentationDragIndicator(.visible)
  }
  
  @ViewBuilder
  func PointView(title: String, systemImage: String, description: String, tintColor: Color = .primary) -> some View {
    HStack(spacing: 25) {
      Image(systemName: systemImage)
        .foregroundColor(tintColor)
        .font(.largeTitle)
        .frame(width: 50)
      
      VStack(alignment: .leading) {
        Text(title)
          .font(.title3)
          .semibold()

        Text(description)
          .foregroundStyle(.gray)
      }
    }
  }
}

#Preview {
  IntroScreen()
}

struct ScaledButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .scaleEffect(configuration.isPressed ? 0.97 : 1)
      .opacity(configuration.isPressed ? 0.7 : 1)
      .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
  }
}

extension ButtonStyle where Self == ScaledButtonStyle {
  
  static var scaled: Self { .init() }
  
}
