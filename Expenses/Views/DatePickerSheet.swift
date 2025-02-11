//
//  DatePickerSheet.swift
//  Expenses
//
//  Created by Santi Ochoa on 2/5/25.
//
import SwiftUI

struct DatePickerSheet: View {
  
  @Environment(\.dismiss) var dismiss
  
  @Binding var originalStartDate: Date
  @Binding var originalEndDate: Date
  
  @State private var startDate: Date = Date()
  @State private var endDate: Date = Date()
  
  init(startDate: Binding<Date>, endDate: Binding<Date>) {
    _originalStartDate = startDate
    _originalEndDate = endDate
  }
  
  var body: some View {
    NavigationStack {
      Form {
        DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
        DatePicker("End Date", selection: $endDate, displayedComponents: .date)
      }
      .scrollDisabled(true)
      .scrollIndicators(.hidden)
      .padding(.top, -20)
      .navigationTitle("Date")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button("Cancel") {
            dismiss()
          }
          .bold()
        }
        
        ToolbarItem(placement: .topBarTrailing) {
          Button("Done") {
            withAnimation {
              originalStartDate = startDate
              originalEndDate = endDate
            }
            dismiss()
          }
          .bold()
        }
      }
    }
  }
}
