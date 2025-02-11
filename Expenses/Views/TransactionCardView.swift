//
//  TransactionCardView.swift
//  Expenses
//
//  Created by Santi Ochoa on 2/4/25.
//

import SwiftUI
import SwiftData

struct TransactionCardView: View {
  
  @Environment(\.modelContext) var modelContext
  
  var transaction: Transaction
  var showCategory: Bool = false
  
  var body: some View {
    
    SwipeAction(cornerRadius: 10, direction: .trailing) {
      
      let isExpense = transaction.category == Category.expense.rawValue
      
      HStack(spacing: 12) {
        
        CircleLetterView(title: transaction.title, color: transaction.color)
        
        VStack(alignment: .leading, spacing: 3) {
          Text(transaction.title)
            .foregroundColor(Color.primary)
          
          Text(transaction.remarks)
            .font(.caption)
            .foregroundStyle(Color.primary.secondary)
          
          Text(formatDate(date: transaction.dateAdded, format: "dd MMM, YYY"))
            .font(.caption2)
            .foregroundStyle(.gray)
          
          if showCategory {
            Text(transaction.category.capitalized)
              .font(.caption2)
              .foregroundStyle(.white)
              .semibold()
              .padding(.horizontal, 8)
              .padding(.vertical, 2)
              .background(transaction.category == Category.income.rawValue ? Color.green.gradient : Color.red.gradient, in: .capsule)
          }
        }
        .lineLimit(1)
        .hSpacing(.leading)
        
        Text("\(isExpense ? "-" : "")\(currency(transaction.amount, allowedDigits: 1))")
          .bold()
          .foregroundStyle(isExpense ? .red : .green)
      }
      .padding(.horizontal, 15)
      .padding(.vertical, 10)
      .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
    } actions: {
      Action(tint: .red, icon: "trash.fill") {
        modelContext.delete(transaction)
      }
    }
  }
}

#Preview {
  TransactionCardView(transaction: exampleTransactions.randomElement()!, showCategory: true)
}

struct CircleLetterView: View {
  
  var title: String
  var color: Color
  
  var body: some View {
    Text("\(title.prefix(1))")
      .font(.title)
      .semibold()
      .foregroundStyle(.white)
      .frame(width: 45, height: 45)
      .background(color.gradient, in: Circle())
  }
}
