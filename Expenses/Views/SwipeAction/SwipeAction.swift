//
//  SwipeAction.swift
//  Expenses
//
//  Created by Santi Ochoa on 2/5/25.
//
import SwiftUI

struct SwipeAction<Content: View>: View {
  
  @StateObject private var swipeController = SwipeController.shared
  
  var cornerRadius: CGFloat = 0
  var direction: SwipeDirection = .trailing
  var isSwipeEnabled: Bool = true
  let id = UUID().uuidString
  
  @ViewBuilder var content: Content
  @ActionBuilder var actions: [Action]
  
  @State private var isEnabled: Bool = false
  @State private var isComingBack: Bool = false
  @State private var scrollOffset: CGFloat = .zero
  
  @Environment(\.colorScheme) var scheme
  
  var body: some View {
    ScrollViewReader { scrollProxy in
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack(spacing: 0) {
          content
            .rotationEffect(.init(degrees: direction == .leading ? -180 : 0))
            .containerRelativeFrame(.horizontal)
            .background (scheme == .dark ? .black : .white, in: RoundedRectangle(cornerRadius: cornerRadius))
            .background {
              Rectangle()
                .fill(.thinMaterial)
                .background (scheme == .dark ? .black : .white, in: RoundedRectangle(cornerRadius: cornerRadius))
                .opacity(scrollOffset == .zero ? 0 : 1)
            }
            .id(id)
            .overlay {
              GeometryReader { proxy in
                let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
                
                Color.clear
                  .preference(key: OffsetKey.self, value: minX)
                  .onPreferenceChange(OffsetKey.self) { newOffset in
                    scrollOffset = newOffset
                    if newOffset != 0 && !isComingBack {
                      swipeController.activeSwipeID = id
                    } else if newOffset == 0 && !isComingBack {
                      swipeController.activeSwipeID = nil
                    }
                  }
              }
            }
          
          ActionButtons {
            withAnimation(.snappy) {
              scrollProxy.scrollTo(id, anchor: direction == .leading ? .topLeading : .topTrailing)
            }
          }
          .opacity(scrollOffset == .zero ? 0 : 1)
        }
        .scrollTargetLayout()
        .visualEffect { $0.offset(x: scrollOffset($1)) }
      }
      .scrollIndicators(.hidden)
      .scrollTargetBehavior(.viewAligned)
      .background {
        if let lastAction = actions.last {
          Rectangle()
            .fill(lastAction.tint)
            .opacity(scrollOffset == .zero ? 0 : 1)
        }
      }
      .rotationEffect(.init(degrees: direction == .leading ? 180 : 0))
      .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
      .onChange(of: swipeController.activeSwipeID) { oldID, newID in
        if newID != id && scrollOffset != .zero || newID == nil {
          isComingBack = true
          withAnimation(.snappy) {
            scrollProxy.scrollTo(id, anchor: direction == .leading ? .topLeading : .topTrailing)
            scrollOffset = .zero
          } completion: {
            isComingBack = false
          }
        }
      }
    }
    .allowsTightening(isEnabled)
  }
  
  @ViewBuilder
  func ActionButtons(resetPositions: @escaping () -> ()) -> some View {
    Rectangle()
      .fill(.clear)
      .frame(width: CGFloat(actions.count) * 100)
      .overlay {
        HStack {
          ForEach(actions) { button in
            Button(action: {
              Task {
                isEnabled = false
                resetPositions()
                try? await Task.sleep(for: .seconds(0.25))
                button.action()
                try? await Task.sleep(for: .seconds(0.15))
                isEnabled = true
              }
            }) {
              Image(systemName: button.icon)
                .font(.title)
                .foregroundColor(button.iconTint)
                .frame(width: 100)
                .frame(maxHeight: .infinity)
                .contentShape(.rect)
            }
            .buttonStyle(.plain)
            .background(button.tint)
            .rotationEffect(.init(degrees: direction == .leading ? -180 : 0))
          }
        }
      }
  }
  
  nonisolated func scrollOffset(_ proxy: GeometryProxy) -> CGFloat {
    let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
    return isSwipeEnabled ? (minX > 0 ? -minX : 0) : -minX
  }
}

class SwipeController: ObservableObject {
  
  static let shared = SwipeController()
  
  @Published var activeSwipeID: String?
}

#Preview {
  ContentView()
    .modelContainer(for: Transaction.self)
}
