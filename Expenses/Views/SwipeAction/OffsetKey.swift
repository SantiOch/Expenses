//
//  OffsetKey.swift
//  Expenses
//
//  Created by Santi Ochoa on 2/6/25.
//
import SwiftUI

struct OffsetKey: PreferenceKey {
  static var defaultValue: CGFloat = .zero
  
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }
  
}
