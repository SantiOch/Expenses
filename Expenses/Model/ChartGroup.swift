//
//  ChartGroup.swift
//  Expenses
//
//  Created by Santi Ochoa on 2/8/25.
//

import SwiftUI

struct ChartGroup: Identifiable {
  let id: UUID = UUID()
  var date: Date
  var categories: [ChartCategory]
  var totalIncome: Double
  var totalExpenses: Double
}

struct ChartCategory: Identifiable {
  let id: UUID = UUID()
  var totalValue: Double
  var category: Category
}
