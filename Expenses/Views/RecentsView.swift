//
//  RecentsView.swift
//  Expenses
//
//  Created by Santi Ochoa on 2/4/25.
//
import SwiftUI
import SwiftData

struct RecentsView: View {
  
  @Environment(\.colorScheme) var colorScheme
  @Environment(\.modelContext) var modelContext
  
  @AppStorage("userName") var userName: String = "Santi"
  
  @State private var startDate: Date = .now.startOfMonth
  @State private var endDate: Date = .now.endOfMonth
  @State private var selectedCategory: Category? = nil
  @State private var showDateSheet: Bool = false
  @State private var selectedSortOption: TransactionSortOption = .date
  
  var body: some View {
    GeometryReader { geometry in
      
      let size = geometry.size
      
      NavigationStack {
        ScrollView(showsIndicators: false) {
          LazyVStack(spacing: 10, pinnedViews: .sectionHeaders) {
            Section {
              
              Button {
                showDateSheet.toggle()
              } label: {
                Text("\(formatDate(date: startDate, format: "dd MMM YY"))" +
                     "- \(formatDate(date: endDate, format: "dd MMM YY"))")
                  .headerStyling()
              }
              
              FilterTransactionsView(startDate: startDate,
                                     endDate: endDate,
                                     sortOrder: selectedSortOption) { transactions in
                
                let filteredTransactions = transactions.filtered(by: selectedCategory)
                
                CardView(
                  income: total(transactions, category: .income),
                  expense: total(transactions, category: .expense)
                )
                
                CustomSegmentedPicker(selectedCategory: $selectedCategory) {
                  let swipeController = SwipeController.shared
                  
                  if swipeController.activeSwipeID != nil {
                    swipeController.activeSwipeID = nil
                    try? await Task.sleep(for: .seconds(0.25))
                  }
                }

                if !filteredTransactions.isEmpty {
                  
                  CustomPickerView(selectedSortOption: $selectedSortOption)
                  
                  ForEach(filteredTransactions) { transaction in
                    NavigationLink {
                      TransactionView(editTransaction: transaction)
                    } label: {
                      TransactionCardView(transaction: transaction)
                    }
                    .buttonStyle(.plain)
                  }
                  
                } else {
                  ContentUnavailableView {
                    Label("No transactions found", systemImage: "creditcard")
                  } description: {
                    Text("There are no transactions to show. Try changing the date range in the filter or adding a new transaction by tapping the plus (+) button in the top right corner of the screen.")
                  }
                  .offset(y: 50)
                }
              }
            } header: {
              Header(size)
            }
          }
          .padding(15)
        }
      }
    }
    .animation(.default, value: selectedSortOption)
    .sheet(isPresented: $showDateSheet) {
      DatePickerSheet(startDate: $startDate, endDate: $endDate)
        .presentationDetents([.fraction(0.25)])
    }
  }
  
  @ViewBuilder
  func Header(_ size: CGSize) -> some View {
    HStack {
      VStack(alignment: .leading, spacing: 5) {
        Text("Welcome!")
          .font(.title)
          .bold()
        
        if !userName.isEmpty {
          Text(userName)
            .font(.callout)
            .foregroundStyle(.gray)
        }
      }
      .visualEffect { $0.scaleEffect(headerScaleFactor(size, proxy: $1), anchor: .topLeading) }
      
      Spacer()
      
      NavigationLink {
        TransactionView()
      } label: {
        Image(systemName: "plus")
          .font(.title3)
          .semibold()
          .foregroundColor(.primary)
      }
    }
    .padding(.bottom, userName.isEmpty ? 10 : 5)
    .background {
      VStack(spacing: 0) {
        Rectangle()
          .fill(.ultraThinMaterial)
        
        Divider()
      }
      .ignoresSafeArea()
      .visualEffect { [safeArea] content, proxy in // Capturing safeArea, because its a mainActor-isolated property
        content.opacity(headerOpacity(proxy: proxy, safeArea: safeArea))
      }
      .padding(.horizontal, -15)
      .padding(.top, -(15 + safeArea.top))
    }
  }
}

#Preview {
  ContentView()
    .modelContainer(for: Transaction.self)
}

enum CategorySelectionOptions: String, CaseIterable {
  case all = "All"
  case income = "Income"
  case expense = "Expense"
  
  var category: Category? {
    switch self {
    case .all: nil
    case .income: .income
    case .expense: .expense
    }
  }
}

extension [Transaction] {
  func sorted(by option: TransactionSortOption) -> [Transaction] {
    switch option {
    case .date: self.sorted(by: { $0.dateAdded > $1.dateAdded })
    case .amount: self.sorted(by: { $0.amount > $1.amount })
    }
  }
  
  func filtered(by category: Category?) -> [Transaction] {
    guard let category = category else { return self }
    return self.filter({ $0.category == category.rawValue })
  }
}

