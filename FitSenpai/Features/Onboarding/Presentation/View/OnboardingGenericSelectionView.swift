//
//  OnboardingGenericSelectionView.swift
//  FitSenpai
//
//  Created by Kevin M on 3/17/25.
//

import SwiftUI

struct OnboardingGenericSelectionView: View {
    @State var selectedItem: FSSignUpItem?
    
    var title: String
    var subtitle: String?
    var selections: [FSSignUpItem]
    var showButton: Bool = false
    
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 8) {
                FSText(text: title, fontStyle: .headers24Medium)
                if let subtitle = self.subtitle {
                    FSText(text: subtitle, fontStyle: .body14)
                }
            }
            .padding(.bottom, 50)
            VStack (alignment: .leading, spacing: 15) {
                ForEach(selections, id: \.self) { item in
                    SelectableIconLabelView(title: item.title, subtitle: item.subtitle, iconName: item.iconName)
                }
            }
            
        }
        .padding(24)
    }
}

#Preview {
    OnboardingGenericSelectionView(title: "Choose your gender", subtitle: "This will be used to personalize your plan", selections: [FSSignUpItem(title: "Male"),FSSignUpItem(title: "Female"),FSSignUpItem(title: "Other")])
}
