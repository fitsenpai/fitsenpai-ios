//
//  FSCircleImageView.swift
//  FitSenpai
//
//  Created by Kevin Andrew Maloles on 11/28/24.
//

import Foundation
import Kingfisher
import SwiftUI

struct CircleImage: View {
        
    var url: URL?
    var heightWidth: CGFloat?
    
    var body: some View {
        KFImage.url(url)
            .placeholder({
                Image("avatarPlaceholder")
                    .resizable()
            })
            .fade(duration: 0.25)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: heightWidth, height: heightWidth)
            .clipShape(Circle())
    }
}
