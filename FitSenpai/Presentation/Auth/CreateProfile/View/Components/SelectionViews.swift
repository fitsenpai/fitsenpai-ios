//
//  SingleSelectionListView.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/1/25.
//

import SwiftUI

struct SingleSelectionListView: View {
    let items: [SelectionItem]
    @Binding var selectedItems: [SelectionItem]
    let onSelection: (SelectionItem) -> Void
    @ObservedObject var viewModel: CreateProfileViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(items) { item in
                SelectionItemView(
                    item: item,
                    isSelected: selectedItems.contains(where: { $0.id == item.id }),
                    isDisabled: viewModel.isSelectionInProgress,
                    action: {
                        onSelection(item)
                    }
                )
            }
        }
    }
}

struct MultipleSelectionListView: View {
    let items: [SelectionItem]
    @Binding var selectedItems: [SelectionItem]
    let onSelection: (SelectionItem) -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(items) { item in
                SelectionItemView(
                    item: item,
                    isSelected: selectedItems.contains(where: { $0.id == item.id }),
                    isDisabled: false,
                    action: {
                        onSelection(item)
                    }
                )
            }
        }
    }
}

struct SelectionItemView: View {
    let item: SelectionItem
    let isSelected: Bool
    let isDisabled: Bool
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button {
            guard !isDisabled || isSelected else { return }
            
            withAnimation(.easeInOut(duration: 0.2)) {
                isPressed = true
                action()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation {
                    isPressed = false
                }
            }
        } label: {
            HStack(spacing: 20) {
                if let icon = item.icon {
                    ZStack {
                        Image(icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                    }
                    .padding(8)
                    .frame(width: 36, height: 36)
                    .background(Circle().fill(isSelected ? Color.gray246 : Color.white))
                    
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    FSTextView(item.title, typography: isSelected ? .p_ui_bold : .p_ui)
                    
                    if let subtitle = item.subtitle {
                        FSText(
                            text: subtitle,
                            fontStyle: .body12
                        )
                    }
                }
                
                Spacer()
                
            }
            .padding(.vertical, 16)
            .padding(.leading, 16)
            .padding(.trailing, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.white : Color.gray246)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected || isPressed ? Color.fsPrimary : Color.clear, lineWidth: isSelected || isPressed ? 2 : 0)
            )
            .contentShape(Rectangle())
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .opacity(isDisabled && !isSelected ? 0.5 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .buttonRepeatBehavior(.disabled)
        .buttonStyle(.plain)
    }
}
