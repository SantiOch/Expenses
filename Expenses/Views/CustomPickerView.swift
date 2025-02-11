//
//  CustomPickerView.swift
//  Expenses
//
//  Created by Santi Ochoa on 2/8/25.
//
import SwiftUI

struct CustomPickerView: View {
  
  @Binding var selectedSortOption: TransactionSortOption
  
  var body: some View {
    HStack {
      Text("Transactions")
        .font(.caption)
        .foregroundStyle(.gray)
        .hSpacing(.leading)
      
      Menu {
        Picker("", selection: $selectedSortOption) {
          ForEach(TransactionSortOption.allCases, id: \.self) { option in
            Label(option.rawValue, systemImage: option.systemName)
              .tag(option)
          }
        }
      } label: {
        Label("Sort", systemImage: "arrow.up.arrow.down")
          .font(.caption)
          .foregroundStyle(.gray)
          .hSpacing(.trailing)
      }
      .frame(width: 50)
    }
  }
}
