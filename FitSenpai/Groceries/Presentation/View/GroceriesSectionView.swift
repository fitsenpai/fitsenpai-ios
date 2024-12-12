//
//  GroceriesSectionView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 12/12/24.
//

import SwiftUI

struct GroceriesSectionView: View {
    @State var selectedItems: [FoodItem]
    @State var foodCategory: FoodCategory
    @State var foodItems: [FoodItem]
    @State var isShowingDetails: Bool

    var categoryHeader: some View {
        HStack {
            ZStack(alignment: .center) {
                RoundedCornerShape(corners: .allCorners, radius: 6)
                    .frame(width: 29, height: 29)
                    .foregroundColor(Color.gray246)
                Image(foodCategory.imageName())
                    .resizable()
                    .frame(width: 16, height: 16)
            }
            
            FSText(text: foodCategory.title(), fontStyle: .body14, color: .fsTitle)
            
            Spacer()
            
            FSText(text: "\(selectedItems.count) of \(foodItems.count) items", fontStyle: .body12, color: .fsSubtitleColor)
        }
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 12) {
                categoryHeader
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            isShowingDetails.toggle()
                        }
                    }

                // Animated details section
                if isShowingDetails {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(foodItems, id: \.self) { item in
                            CheckboxLabelView(
                                title: item.name,
                                detailInfo: item.amount,
                                isChecked: selectedItems.contains { $0.name == item.name },
                                onItemSelected: {
                                    selectedItems.append(item)
                                },
                                onItemDeselected: {
                                    selectedItems.removeAll { $0.name == item.name }
                                }
                            )
                        }
                    }
                    .transition(.opacity.combined(with: .move(edge: .top))) // Smooth transition
                }
            }
            .padding(12)
            .padding(.trailing, 40)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray230, lineWidth: 1)
            }
            
            // Chevron button positioned above the expanded content
            Button(action: {
                withAnimation(.easeInOut) {
                    isShowingDetails.toggle()
                }
            }, label: {
                Image(isShowingDetails ? "ic_chevron_down" : "ic_chevron_right")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .rotationEffect(.degrees(isShowingDetails ? 90 : 0))
                    .animation(.easeInOut, value: isShowingDetails)
            })
            .padding([.trailing, .top], 16) // Adjust padding to avoid overlapping
        }
    }
}

#Preview {
    GroceriesSectionView(selectedItems: [], foodCategory: .proteins, foodItems: [FoodItem(name: "Grilled chicken", amount: "750g"), FoodItem(name: "Salmon", amount: "750g"), FoodItem(name: "Whey protein", amount: "300g")], isShowingDetails: false)
}
