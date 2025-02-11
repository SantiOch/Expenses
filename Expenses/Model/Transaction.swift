//
//  Transaction.swift
//  Expenses
//
//  Created by Santi Ochoa on 2/4/25.
//

import SwiftUI
import SwiftData

@Model
class Transaction: Identifiable {
  
  var id: UUID = UUID()
  
  var title: String
  var remarks: String
  var amount: Double
  var dateAdded: Date
  var category: String
  var tintColor: String
  
  init(title: String, remarks: String, amount: Double, dateAdded: Date, category: Category, tintColor: TintColor) {
    self.title = title
    self.remarks = remarks
    self.amount = amount
    self.dateAdded = dateAdded
    self.category = category.rawValue
    self.tintColor = tintColor.color
  }
  
  @Transient //Not necessary, because SwiftData doesn't store computed properties
  var color: Color { tints.first(where: { $0.color == tintColor })?.value ?? .blue }
  
  @Transient
  var tint: TintColor? {
    tints.first(where: { $0.color == tintColor })
  }
  
  @Transient
  var rawCategory: Category? {
    Category(rawValue: category)
  }
}

var exampleTransactions: [Transaction] = [
  .init(
    title: "Headphones",
    remarks: "Bought a new pair of headphones.",
    amount: 199.99,
    dateAdded: Date(),
    category: .expense,
    tintColor: tints.randomElement()!
  ),
  .init(
    title: "Mouse",
    remarks: "Needed a new mouse for gaming.",
    amount: 49.99,
    dateAdded: Date(),
    category: .expense,
    tintColor: tints.randomElement()!
  ),
  .init(
    title: "Keyboard",
    remarks: "Keyboard upgrade for work.",
    amount: 149.99,
    dateAdded: Date(),
    category: .expense,
    tintColor: tints.randomElement()!
  ),
  .init(
    title: "Monitor",
    remarks: "Monitor replacement for better viewing.",
    amount: 299.99,
    dateAdded: Date(),
    category: .expense,
    tintColor: tints.randomElement()!
  ),
  .init(
    title: "Salary",
    remarks: "Received my monthly salary.",
    amount: 3000.0,
    dateAdded: .now,
    category: .income,
    tintColor: tints.randomElement()!
  ),
  .init(
    title: "Laptop",
    remarks: "Bought a new laptop for work.",
    amount: 1299.99,
    dateAdded: Date(),
    category: .expense,
    tintColor: tints.randomElement()!
  ),
  .init(
    title: "Tablet",
    remarks: "Bought a new tablet for entertainment.",
    amount: 399.99,
    dateAdded: Date(),
    category: .expense,
    tintColor: tints.randomElement()!
  ),
  .init(
    title: "Smartphone",
    remarks: "Bought a new smartphone for staying connected.",
    amount: 799.99,
    dateAdded: Date(),
    category: .expense,
    tintColor: tints.randomElement()!
  ),
  .init(
    title: "Lottery",
    remarks: "Won a small prize in the lottery.",
    amount: 1000.0,
    dateAdded: Date(),
    category: .income,
    tintColor: tints.randomElement()!
  ),
  .init(
    title: "Stocks",
    remarks: "Sold some stocks and made a profit.",
    amount: 1000.0,
    dateAdded: Date(),
    category: .income,
    tintColor: tints.randomElement()!
  ),
  
]

var randomTransactionNames: [String] = [
  "Headphones",
  "Mouse",
  "Keyboard",
  "Monitor",
  "Laptop",
  "Tablet",
  "Smartphone",
  "Camera",
  "Speakers",
  "Gaming PC",
  "Gaming Console",
  "VR Headset",
  "Lights",
  "Clothing",
  "Books",
  "Electronics",
  "Groceries",
  "Transportation",
  "Utilities",
  "Entertainment",
  "Miscellaneous",
]

var randomRemarks: [String] = [
  "Bought a new pair of headphones.",
  "Needed a new mouse for gaming.",
  "Keyboard upgrade for work.",
  "Monitor replacement for better viewing.",
  "Laptop upgrade for better performance.",
  "Tablet purchase for entertainment.",
  "New smartphone for staying connected.",
  "Camera upgrade for photography.",
  "Speakers for home entertainment.",
  "Gaming PC upgrade for enhanced gaming.",
  "Gaming console purchase for gaming.",
  "VR headset for immersive gaming.",
  "Lighting setup for home ambiance.",
  "New clothing for work.",
  "Book purchase for personal growth.",
  "Electronics repair needed.",
  "Grocery shopping for the week.",
  "Transportation expense.",
  "Utilities bill payment.",
  "Movie night at home.",
  "Miscellaneous expense.",
]
