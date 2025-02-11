//
//  TransactionSortOption.swift
//  Expenses
//
//  Created by Santi Ochoa on 2/8/25.
//

enum TransactionSortOption: String, CaseIterable {
  case date = "Date"
  case amount = "Amount"
  
  var systemName: String {
    switch self {
    case .date:
      return "calendar"
    case .amount:
      return "dollarsign"
    }
  }
}
