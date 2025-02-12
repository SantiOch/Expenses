//
//  SearchView.swift
//  Expenses
//
//  Created by Santi Ochoa on 2/7/25.
//
import SwiftUI
import Combine

struct SearchView: View {
  
  @State private var searchText: String = ""
  @State private var filterText: String = ""
  let searchPubliser = PassthroughSubject<String, Never>()
  @State private var selectedSortOption: TransactionSortOption = .date
  
  var body: some View {
    NavigationStack {
      ScrollView {
        LazyVStack(spacing: 12) {
          FilterTransactionsView(category: nil, searchText: filterText, sortOrder: selectedSortOption) { transactions in
           
            if !transactions.isEmpty {
              
              CustomPickerView(selectedSortOption: $selectedSortOption)
              
              ForEach(transactions) { transaction in
                NavigationLink {
                  TransactionView(editTransaction: transaction)
                } label: {
                  TransactionCardView(transaction: transaction, showCategory: true)
                }
              }
            }
            
            if transactions.isEmpty && !filterText.isEmpty {
              ContentUnavailableView.search(text: filterText)
                .offset(y: 100)
            }
          }
        }
        .padding()
      }
      .onChange(of: searchText) { oldValue, newValue in
        
        if newValue.isEmpty { filterText = "" }
        
        searchPubliser.send(newValue)
      }
      .onReceive(searchPubliser.debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)) { filterText = $0 }
      .searchable(text: $searchText)
      .navigationTitle("Search")
    }
    .overlay {
      if filterText.isEmpty {
        ContentUnavailableView("Search Transactions", systemImage: "magnifyingglass")
      }
    }
    .animation(.snappy, value: selectedSortOption)
  }
}

#Preview {
  ContentView()
    .modelContainer(for: Transaction.self)
}
