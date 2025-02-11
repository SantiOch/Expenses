//
//  FilterTransactionsView.swift
//  Expenses
//
//  Created by Santi Ochoa on 2/8/25.
//

import SwiftUI
import SwiftData

struct FilterTransactionsView<Content: View>: View {
  
  var content: ([Transaction]) -> Content
  @Query(animation: .snappy) var transactions: [Transaction]
  
  init (
    category: Category?,
    searchText: String,
    @ViewBuilder content: @escaping ([Transaction]) -> Content
  ) {
    
    let rawValue = category?.rawValue ?? ""
    
    let predicate = #Predicate<Transaction> { transaction in
      
      return (transaction.title.localizedStandardContains(searchText) ||
              transaction.remarks.localizedStandardContains(searchText)) &&
      (rawValue.isEmpty ? true : transaction.category == rawValue)
    }
    
    _transactions = Query(filter: predicate, sort: [
      SortDescriptor(\Transaction.dateAdded, order: .reverse)
    ], animation: .snappy)
    
    self.content = content
  }
  
  init (
    category: Category?,
    searchText: String,
    sortOrder: TransactionSortOption,
    @ViewBuilder content: @escaping ([Transaction]) -> Content
  ) {
    
    let rawValue = category?.rawValue ?? ""
    
    let predicate = #Predicate<Transaction> { transaction in
      
      return (transaction.title.localizedStandardContains(searchText) ||
              transaction.remarks.localizedStandardContains(searchText)) &&
      (rawValue.isEmpty ? true : transaction.category == rawValue)
    }
    
    let sortDescriptor: SortDescriptor<Transaction>
    
    switch sortOrder {
    case .date:
      sortDescriptor = SortDescriptor(\Transaction.dateAdded, order: .reverse)
    case .amount:
      sortDescriptor =  SortDescriptor(\Transaction.amount, order: .reverse)
    }
    
    _transactions = Query(filter: predicate, sort: [sortDescriptor], animation: .snappy)
    
    self.content = content
  }
  
  init (
    startDate: Date,
    endDate: Date,
    @ViewBuilder content: @escaping ([Transaction]) -> Content
  ) {
    
    let predicate = #Predicate<Transaction> { transaction in
      return transaction.dateAdded >= startDate && transaction.dateAdded <= endDate
    }
    
    _transactions = Query(filter: predicate, sort: [
      SortDescriptor(\Transaction.dateAdded, order: .reverse)
    ], animation: .snappy)
    
    self.content = content
  }
  
  init (
    startDate: Date,
    endDate: Date,
    category: Category?,
    sortOrder: TransactionSortOption = .date,
    @ViewBuilder content: @escaping ([Transaction]) -> Content
  ) {
    
    let rawValue = category?.rawValue ?? ""
    
    let predicate = #Predicate<Transaction> { transaction in
      (transaction.dateAdded >= startDate && transaction.dateAdded <= endDate) &&
      (rawValue.isEmpty ? true : transaction.category == rawValue)
    }
    
    let sortDescriptor: SortDescriptor<Transaction>
    
    switch sortOrder {
    case .date:
      sortDescriptor = SortDescriptor(\Transaction.dateAdded, order: .reverse)
    case .amount:
      sortDescriptor =  SortDescriptor(\Transaction.amount, order: .reverse)
    }
    
    _transactions = Query(filter: predicate, sort: [sortDescriptor], animation: .snappy)
    
    self.content = content
  }
  
  init (
    startDate: Date,
    endDate: Date,
    sortOrder: TransactionSortOption,
    @ViewBuilder content: @escaping ([Transaction]) -> Content
  ) {
    
    
    let predicate = #Predicate<Transaction> { transaction in
      (transaction.dateAdded >= startDate && transaction.dateAdded <= endDate)
    }
    
    let sortDescriptor: SortDescriptor<Transaction>
    
    switch sortOrder {
    case .date:
      sortDescriptor = SortDescriptor(\Transaction.dateAdded, order: .reverse)
    case .amount:
      sortDescriptor =  SortDescriptor(\Transaction.amount, order: .reverse)
    }
    
    _transactions = Query(filter: predicate, sort: [sortDescriptor], animation: .snappy)
    
    self.content = content
  }
  
  var body: some View {
    content(transactions)
  }
}

