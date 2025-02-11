//
//  SwipeDirection.swift
//  Expenses
//
//  Created by Santi Ochoa on 2/6/25.
//
import SwiftUI

enum SwipeDirection {
  case leading
  case trailing
  
  var alignment: Alignment {
    switch self {
    case .leading:
      return .leading
    case .trailing:
      return .trailing
    }
  }
}
