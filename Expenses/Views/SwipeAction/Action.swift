//
//  Action.swift
//  Expenses
//
//  Created by Santi Ochoa on 2/6/25.
//
import SwiftUI

struct Action: Identifiable {
  var id: UUID = UUID()
  var tint: Color
  var icon: String
  var iconTint: Color = .white
  var action: () -> ()
}

@resultBuilder
struct ActionBuilder {
  static func buildBlock(_ components: Action...) -> [Action] {
    return components
  }
}
