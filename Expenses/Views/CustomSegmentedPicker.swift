//
//  CustomSegmentedPicker.swift
//  Expenses
//
//  Created by Santi Ochoa on 2/6/25.
//
import SwiftUI

struct CustomSegmentedPicker<S: Shape>: View {

  var outsideShape: S
  var insideShape: S
  
  @Binding var selectedCategory: Category?
  
  var onTap: () async -> ()
  
  @Namespace private var animation
  
  init(
    outsideShape: S = .rect(cornerRadius: 12),
    insideShape: S = .rect(cornerRadius: 9),
    selectedCategory: Binding<Category?>,
    onTap: @escaping () async -> ()
  ) {
    self.outsideShape = outsideShape
    self.insideShape = insideShape
    _selectedCategory = selectedCategory
    self.onTap = onTap
  }
  
  var body: some View {
    HStack(spacing: 0) {
      HStack {
        ForEach(CategorySelectionOptions.allCases, id: \.rawValue) { option in
          Text(option.rawValue)
            .hSpacing()
            .padding(.vertical, 10)
            .background {
              if option.category == selectedCategory {
                insideShape
                  .fill(.gray.opacity(0.2))
                  .matchedGeometryEffect(id: "SelectedCategory", in: animation)
              }
            }
            .contentShape(insideShape)
            .onTapGesture {
              Task { @MainActor in
                await onTap()
                withAnimation(.snappy(duration: 0.5)) {
                  selectedCategory = option.category
                }
              }
            }
        }
      }
      .padding(3)
    }
    .background(.ultraThinMaterial, in: outsideShape)
    .padding(.vertical, 3)
  }
}

#Preview {
  ContentView()
    .modelContainer(for: Transaction.self)
}
