//
//  ViewExtensions.swift
//  Expenses
//
//  Created by Santi Ochoa on 2/4/25.
//
import SwiftUI

extension View {
  
  @ViewBuilder
  func hSpacing(_ alignment: Alignment = .center) -> some View {
    self
      .frame(maxWidth: .infinity, alignment: alignment)
  }
  
  @ViewBuilder
  func vSpacing(_ alignment: Alignment = .center) -> some View {
    self
      .frame(maxHeight: .infinity, alignment: alignment)
  }
  
  @ViewBuilder
  func semibold() -> some View {
    self.fontWeight(.semibold)
  }
  
  @available(iOSApplicationExtension, unavailable)
  var safeArea: UIEdgeInsets {
    if let windowScene = (UIApplication.shared.connectedScenes.first as? UIWindowScene) {
      return windowScene.keyWindow?.safeAreaInsets ?? .zero
    }
    
    return .zero
  }
  
  func formatDate(date: Date, format: String) -> String {
    
    let formatter = DateFormatter()
    formatter.dateFormat = format
    
    return formatter.string(from: date)
  }
  
  func currency(_ value: Double, allowedDigits: Int = 2) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.maximumFractionDigits = allowedDigits
    
    return formatter.string(from: NSNumber(value: value)) ?? ""
  }
  
  var currencySymbol: String {
    let locale = Locale.current
    return locale.currencySymbol ?? ""
  }
  
  nonisolated func total(_ transactions: [Transaction], category: Category) -> Double {
    return transactions.filter { $0.category == category.rawValue }.reduce(Double.zero) { result, transaction in
      return result + transaction.amount
    }
  }
  
  nonisolated func headerOpacity(proxy: GeometryProxy, safeArea: UIEdgeInsets) -> CGFloat {
    let minY = proxy.frame(in: .scrollView).minY + safeArea.top
    return minY > 0 ? 0 : (-minY / 15)
  }
  
  nonisolated func headerScaleFactor(_ size: CGSize, proxy: GeometryProxy) -> CGFloat {
    
    let minY = proxy.frame(in: .scrollView).minY
    let screenHeight = size.height
    
    let progress: CGFloat = minY / screenHeight
    let scale = min(max(progress, 0), 1) * 0.6
    
    return 1 + scale
  }
  
  func headerStyling() -> some View {
    self.modifier(HeaderModifier())
  }
}

struct HeaderModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
    .font(.caption)
    .foregroundStyle(.gray)
    .hSpacing(.leading)
  }
}
