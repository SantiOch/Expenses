//
//  TextFieldView.swift
//  Expenses
//
//  Created by Santi Ochoa on 2/6/25.
//

import SwiftUI

struct TextFieldView: View {
  
  @Binding var value: String
  
  var onChange: (String) async -> TypingState
  
  @State private var state: TypingState = .typing
  @State private var invalidTrigger: Bool = false
  
  var body: some View {
    HStack(spacing: 10) {
      ForEach(0..<4, id: \.self) { index in
        characterView(index)
      }
    }
    .animation(.easeInOut(duration: 0.3), value: value)
    .compositingGroup()
    .phaseAnimator([0, 10, -10, 10, -5, 5, 0], trigger: invalidTrigger) { $0.offset(x: $1) } animation: { _ in .linear(duration: 0.06) }
    .onChange(of: value) {
      Task { @MainActor in
        state = await onChange(value)
        if state == .incorrect { invalidTrigger.toggle() }
      }
    }
    .animation(.snappy, value: state)
  }
  
  @ViewBuilder
  func characterView(_ index: Int) -> some View {
    VStack {
      Capsule()
        .fill(borderColor(index))
        .frame(height: 5)
        .vSpacing(.bottom)
    }
    .frame(width: 40, height: 50)
    .overlay {
      let stringValue = stringValue(index)
      
      if stringValue != "" {
        Text(stringValue)
          .font(.title2)
          .semibold()
          .transition(.blurReplace)
      }
    }
  }
  
  func stringValue(_ index: Int) -> String {
    if value.count > index {
      let startIndex = value.index(value.startIndex, offsetBy: index)
      return String(value[startIndex])
    }
    
    return ""
  }
  
  func borderColor(_ index: Int) -> Color {
    switch state {
    case .typing: value.count == index ? .primary : .gray
    case .correct: .green
    case .incorrect: .red
    }
  }
}

enum TypingState {
  case typing
  case correct
  case incorrect
}
