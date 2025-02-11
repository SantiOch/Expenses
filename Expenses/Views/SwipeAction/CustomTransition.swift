//
//  CustomTransition.swift
//  Expenses
//
//  Created by Santi Ochoa on 2/6/25.
//
import SwiftUI

struct CustomTransition: Transition {
  func body(content: Content, phase: TransitionPhase) -> some View {
    content
      .mask {
        GeometryReader { proxy in
          let size = proxy.size
          
          Rectangle()
            .offset(y: phase == .identity ? 0 : -size.height)
        }
        .containerRelativeFrame(.horizontal)
      }
  }
}
