//
//  ChartView.swift
//  Expenses
//
//  Created by Santi Ochoa on 2/8/25.
//

import SwiftUI
import SwiftData
import Charts

struct ChartTabView: View {
  
  @Query(animation: .snappy) var transactions: [Transaction]
  @State private var chartGroups: [ChartGroup] = []
  @State private var isLoading: Bool = true
  
  var body: some View {
    NavigationStack {
      ScrollView {
        LazyVStack(spacing: 10) {
          
          ChartView()
            .frame(height: 200)
            .padding(10)
            .padding(.top, 10)
            .background(.thinMaterial, in: .rect(cornerRadius: 10))
          
          ForEach(chartGroups) { group in
            VStack(alignment: .leading) {
              
              Text(formatDate(date: group.date, format: "MMM yy"))
                .headerStyling()
              
              NavigationLink {
                ListOfExpenses(month: group.date)
              } label: {
                CardView(income: group.totalIncome, expense: group.totalExpenses)
              }
              .buttonStyle(.scaled)
            }
          }
        }
        .padding(15)
      }
      .navigationTitle("Chart")
      .onAppear(perform: createChartGroup)
    }
  }
  
  @ViewBuilder
  func ChartView() -> some View {
    Chart {
      ForEach(chartGroups) { group in
        ForEach(group.categories) { chart in
          BarMark(
            x: .value("Month", formatDate(date: group.date, format: "MMM yy")),
            y: .value(chart.category.rawValue, chart.totalValue)
            )
          .cornerRadius(4)
          .position(by: .value("Category", chart.category.rawValue), axis: .horizontal)
          .foregroundStyle(by: .value("Category", chart.category.rawValue))
        }
      }
    }
    .chartScrollableAxes(.horizontal)
    .chartXVisibleDomain(length: 4)
    .chartLegend(position: .bottom, alignment: .trailing)
    .chartYAxis {
      AxisMarks(position: .leading) { value in
        let doubleValue = value.as(Double.self) ?? 0
        
        AxisGridLine()
        AxisTick()
        AxisValueLabel {
          Text(axisLabel(doubleValue))
        }
        
      }
    }
    .chartOverlay { _ in
      if isLoading {
        ProgressView("Loading...")
      } else if chartGroups.isEmpty {
         ContentUnavailableView {
           Label("No data available", systemImage: "exclamationmark.triangle")
         } description: {
           Text("Please add transactions to view a chart.")
         }
       }
    }
    .chartForegroundStyleScale(range: [.green, .red])
    .animation(.snappy, value: isLoading)
  }
  
  func createChartGroup() {
    Task.detached(priority: .high) {
      
      await MainActor.run {
        self.isLoading = self.chartGroups.count == 0 ? true : false
      }
      
      // Simulate loading time
      try? await Task.sleep(for: .seconds(1))
      
      let calendar = Calendar.current
      
      let groupedByDate = await Dictionary(grouping: transactions) { transaction in
        let components = calendar.dateComponents([.month, .year], from: transaction.dateAdded)
        
        return components
      }
      
      let sortedGroups = groupedByDate.sorted {
        let date1 = calendar.date(from: $0.key) ?? .now
        let date2 = calendar.date(from: $1.key) ?? .now
        
        return calendar.compare(date1, to: date2, toGranularity: .day) == .orderedDescending
      }
      
      let chartGroups = sortedGroups.compactMap { dict -> ChartGroup? in
        
        let date = calendar.date(from: dict.key) ?? .now
        let income = dict.value.filter { $0.category == Category.income.rawValue }
        let expense = dict.value.filter { $0.category == Category.expense.rawValue }
        
        let incomeTotalValue = total(income, category: .income)
        let expenseTotalValue = total(expense, category: .expense)
        
        return .init(
          date: date,
          categories: [
            .init(totalValue: incomeTotalValue, category: .income),
            .init(totalValue: expenseTotalValue, category: .expense)
          ],
          totalIncome: incomeTotalValue,
          totalExpenses: expenseTotalValue
        )
      }
      
      // Has to be done on the main thread
      await MainActor.run {
        self.chartGroups = chartGroups
        self.isLoading = false
      }
    }
  }
  
  func axisLabel(_ value: Double) -> String {
      let intValue = Int(value)
      
      if intValue < 1000 { return "\(intValue)" }
      
      let kValue = value / 1000
      
      return "\(String(format: "%.1f", kValue))K"
  }
}

struct ListOfExpenses: View {
  
  let month: Date
  
  var body: some View {
    ScrollView {
      LazyVStack {
        Section {
          FilterTransactionsView(startDate: month.startOfMonth, endDate: month.endOfMonth, category: .income) { transactions in
            ForEach(transactions) { transaction in
              NavigationLink {
                TransactionView(editTransaction: transaction)
              } label: {
                TransactionCardView(transaction: transaction)
              }
              .buttonStyle(.plain)
            }
          }
        } header: {
          Text("Income")
            .headerStyling()
        }
        
        Section {
          FilterTransactionsView(startDate: month.startOfMonth, endDate: month.endOfMonth, category: .expense) { transactions in
            ForEach(transactions) { transaction in
              NavigationLink {
                TransactionView(editTransaction: transaction)
              } label: {
                TransactionCardView(transaction: transaction)
              }
              .buttonStyle(.plain)
            }
          }
        } header: {
          Text("Expenses")
            .headerStyling()
            .padding(.top, 5)
        }
      }
      .padding(15)
    }
    .navigationTitle(formatDate(date: month.endOfMonth, format: "MMMM yyyy"))
    .navigationBarTitleDisplayMode(.inline)
  }
}

#Preview {
  ContentView()
    .modelContainer(for: Transaction.self)
}
 
