//
//  CardView.swift
//  Expenses
//
//  Created by Santi Ochoa on 2/4/25.
//

import SwiftUI
import WidgetKit

struct CardView: View {
  
  var income: Double
  var expense: Double
  var family: WidgetFamily = .systemMedium
  
  var body: some View {
    switch family {
    case .systemSmall:
      SystemSmallView()
    case .systemMedium:
      SystemMediumView()
    default:
      SystemMediumView()
    }
  }
  
  @ViewBuilder
  func SystemMediumView() -> some View {
    ZStack {
      RoundedRectangle(cornerRadius: 12)
        .fill(.ultraThinMaterial)
      
      VStack(spacing: 0) {
        HStack(spacing: 12) {
          Text("\(currency(income - expense))")
            .font(.title)
            .bold()
          
          Image(systemName: expense > income ? "chart.line.downtrend.xyaxis" : "chart.line.uptrend.xyaxis")
            .font(.title3)
            .foregroundStyle(expense > income ? .red : .green)
        }
        .padding(.bottom, 25)
        
        HStack(spacing: 0) {
          ForEach(Category.allCases, id: \.rawValue) { category in
            let symbol = category == .income ? "arrow.down" : "arrow.up"
            let tint: Color = category == .income ? .green : .red
            
            HStack(spacing: 10) {
              Image(systemName: symbol)
                .font(.callout)
                .bold()
                .foregroundStyle(tint)
                .frame(width: 35, height: 35)
                .background {
                  Circle()
                    .fill(tint.opacity(0.2))
                }
              
              VStack(alignment: .leading, spacing: 5) {
                Text(category.rawValue)
                  .font(.caption2)
                  .foregroundStyle(.gray)
                
                Text(currency(category == .income ? income : expense, allowedDigits: 0))
                  .font(.callout)
                  .semibold()
                  .foregroundStyle(.primary)
              }
              
              if category == .income {
                Spacer()
              }
            }
          }
        }
        .lineLimit(1)
        .minimumScaleFactor(0.5)
      }
      .contentTransition(.numericText())
      .animation(.default, value: income)
      .animation(.default, value: expense)
      .padding([.horizontal, .bottom], 25)
      .padding(.top, 15)
    }
  }
  
  @ViewBuilder
  func SystemSmallView() -> some View {
    ZStack (alignment: .leading) {
      RoundedRectangle(cornerRadius: 12)
        .fill(.ultraThinMaterial)
      
      VStack(alignment: .leading) {
        HStack(spacing: 12) {
          
          Text("\(currency(income - expense, allowedDigits: 1))")
            .font(.title3)
            .bold()
          
          Image(systemName: income < expense ? "chart.line.downtrend.xyaxis" : "chart.line.uptrend.xyaxis")
            .font(.subheadline)
            .foregroundStyle(income < expense ? .red : .green)
        }
        .lineLimit(1)
        .minimumScaleFactor(0.5)
        .padding(.bottom, 10)
        
        VStack (spacing: 10) {
          
          ForEach(Category.allCases, id: \.rawValue) { category in
            let symbol = category == .income ? "arrow.down" : "arrow.up"
            let tint: Color = category == .income ? .green : .red
            
            HStack(spacing: 10) {
              
              Image(systemName: symbol)
                .font(.callout)
                .bold()
                .foregroundStyle(tint)
                .frame(width: 35, height: 35)
                .background {
                  Circle()
                    .fill(tint.opacity(0.2))
                }
              
              VStack(alignment: .leading, spacing: 2) {
                Text(category.rawValue)
                  .font(.caption2)
                  .foregroundStyle(.gray)
                
                Text(currency(category == .income ? income : expense, allowedDigits: 0))
                  .font(.callout)
                  .semibold()
                  .foregroundStyle(.primary)
              }
            }
            .hSpacing(.leading)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
          }
        }
      }
      .vSpacing(.bottom)
      .padding(family == .systemSmall ? 15 : 0)
    }
  }
}

#Preview {
  CardView(income: 4325, expense: 2345)
}
