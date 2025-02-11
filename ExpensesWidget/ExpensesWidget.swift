//
//  ExpensesWidget.swift
//  ExpensesWidget
//
//  Created by Santi Ochoa on 2/8/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
  func placeholder(in context: Context) -> WidgetEntry {
    WidgetEntry(date: Date())
  }
  
  func getSnapshot(in context: Context, completion: @escaping (WidgetEntry) -> ()) {
    let entry = WidgetEntry(date: Date())
    completion(entry)
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    var entries: [WidgetEntry] = []
    
    entries.append(.init(date: .now))
    
    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }
}

struct WidgetEntry: TimelineEntry {
  let date: Date
}

struct ExpensesWidgetEntryView : View {
  var entry: Provider.Entry
  
  @Environment(\.widgetFamily) var family
  
  let income = 233000.23
  let expense = 1234.431
  
  var body: some View {
    FilterTransactionsView(startDate: .now.startOfMonth, endDate: .now.endOfMonth) { transactions in
    CardView(
      income: total(transactions, category: .income),
      expense: total(transactions, category: .expense),
      family: family
      )
    }
  }
}

struct ExpensesWidget: Widget {
  let kind: String = "ExpensesWidget"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      ExpensesWidgetEntryView(entry: entry)
        .containerBackground(.fill.tertiary, for: .widget)
        .modelContainer(for: Transaction.self)
    }
    .supportedFamilies([.systemMedium, .systemSmall])
    .contentMarginsDisabled()
    .configurationDisplayName("My Widget")
    .description("This is an example widget.")
  }
}

#Preview(as: .systemSmall) {
  ExpensesWidget()
} timeline: {
  WidgetEntry(date: .now)
}
