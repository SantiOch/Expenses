//
//  TintColor.swift
//  Expenses
//
//  Created by Santi Ochoa on 2/4/25.
//

import SwiftUI

struct TintColor: Identifiable {
  
  let id: UUID = UUID()
  var color: String
  var value: Color
}

var tints: [TintColor] = [
  .init(color: "blue", value: .blue),
  .init(color: "green", value: .green),
  .init(color: "yellow", value: .yellow),
  .init(color: "red", value: .red),
  .init(color: "purple", value: .purple),
  .init(color: "orange", value: .orange),
  .init(color: "pink", value: .pink),
]
