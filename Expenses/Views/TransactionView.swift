//
//  NewExpenseView.swift
//  Expenses
//
//  Created by Santi Ochoa on 2/7/25.
//

import SwiftUI
import SwiftData
import WidgetKit

struct TransactionView: View {
  
  @Environment(\.modelContext) var modelContext
  @Environment(\.dismiss) var dismiss
  
  var editTransaction: Transaction?
  
  @State private var title: String = ""
  @State private var remarks: String = ""
  @State private var amount: Double = .zero
  @State private var dateAdded: Date = .now
  @State private var category: Category = .income
  @State private var tint = tints.randomElement()!
  
  var body: some View {
    ScrollView(.vertical) {
      VStack(spacing: 15) {
        Text ("Preview")
          .headerStyling()
        
        TransactionCardView(
          transaction: .init(
            title: title.isEmpty ? "Title" : title,
            remarks: remarks.isEmpty ? "Remarks" : remarks,
            amount: amount,
            dateAdded: dateAdded,
            category: category,
            tintColor: tint
          ),
          isSwipeEnabled: false
        )
        
        CustomTextField("Title", placeholder: "Camera", value: $title)
        
        CustomTextField("Remarks", placeholder: "Bought a camera for my wife", value: $remarks)
        
        VStack(alignment: .leading) {
          Text("Ammount and Category")
            .headerStyling()

          
          HStack(spacing: 15) {
            HStack(spacing: 4) {
              Text(currencySymbol)
                .font(.callout)
                .bold()
              
              TextField("0.0", value: $amount, formatter: numberFormatter)
                .keyboardType(.decimalPad)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 12)
            .background(.thinMaterial, in: .rect(cornerRadius: 10))
            .frame(maxWidth: 130)
            
            CustomCheckBox()
          }
        }
        
        VStack(alignment: .leading) {
          Text("Date")
            .headerStyling()
          
          DatePicker("", selection: $dateAdded, displayedComponents: .date)
            .datePickerStyle(.graphical)
            .padding(.horizontal, 15)
            .padding(.vertical, 12)
            .background(.thinMaterial, in: .rect(cornerRadius: 10))
        }
      }
      .padding (15)
    }
    .navigationTitle("\(editTransaction == nil ? "Add" : "Edit") Transaction")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button("Save", action: save)
          .disabled(title.isEmpty || amount.isZero || remarks.isEmpty)
      }
    }
    .onAppear(perform: loadTransaction)
  }
  
  func loadTransaction() {
    guard let editTransaction else { return }
    
    title = editTransaction.title
    remarks = editTransaction.remarks
    amount = editTransaction.amount
    dateAdded = editTransaction.dateAdded
   
    if let category = editTransaction.rawCategory {
      self.category = category
    }
    
    if let tint = editTransaction.tint {
      self.tint = tint
    }
  }
  
  func save() {
    
    if let editTransaction {
   
      editTransaction.title = title
      editTransaction.remarks = remarks
      editTransaction.amount = amount
      editTransaction.category = category.rawValue
      editTransaction.dateAdded = dateAdded
      
    } else {
   
      let transaction = Transaction(
        title: title,
        remarks: remarks,
        amount: amount,
        dateAdded: dateAdded,
        category: category,
        tintColor: tint
      )
      
      modelContext.insert(transaction)
      
    }

    WidgetCenter.shared.reloadAllTimelines()
    dismiss()
  }
  
  @ViewBuilder
  func CustomTextField(_ title: String, placeholder: String, value: Binding<String>) -> some View {
    VStack(alignment: .leading) {
      Text(title)
        .headerStyling()
      
      TextField(placeholder, text: value)
        .padding(.horizontal, 15)
        .padding(.vertical, 12)
        .background(.thinMaterial, in: .rect(cornerRadius: 10))
    }
  }
  
  @ViewBuilder
  func CustomCheckBox() -> some View {
    HStack(spacing: 10) {
      ForEach(Category.allCases, id: \.rawValue) { category in
        HStack(spacing: 5) {
          ZStack {
            Image(systemName: "circle")
              .font(.title3)
              .foregroundStyle(.blue)
            
            if self.category == category {
              Image(systemName: "circle.fill")
                .font(.caption)
                .foregroundStyle(.blue)
            }
          }
          
          Text(category.rawValue)
            .font(.callout)
        }
        .contentShape(.rect)
        .onTapGesture {
          withAnimation {
            self.category = category
          }
        }
      }
    }
    .padding(.horizontal, 15)
    .padding(.vertical, 12)
    .hSpacing(.leading)
    .background(.thinMaterial, in: .rect(cornerRadius: 10))
  }
  
  var numberFormatter: NumberFormatter {
    let formatter = NumberFormatter()
    
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 2
    
    return formatter
  }
}

#Preview {
  ContentView()
    .modelContainer(for: Transaction.self)
}
