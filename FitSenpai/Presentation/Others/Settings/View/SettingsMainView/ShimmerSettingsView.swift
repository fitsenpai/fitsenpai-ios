//
//  ShimmerSettingsView.swift
//  FitSenpai
//
//  Created by AI Assistant on 1/12/25.
//

import SwiftUI

struct ShimmerSettingsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            
            VStack(alignment: .leading, spacing: 4) {
                ShimmerSettingsSectionHeaderView(title: "PROFILE")
                VStack(alignment: .leading, spacing: 12) {
                    ShimmerSettingsProfileHeaderView()
                    ShimmerSettingsSectionView(itemCount: 5)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                ShimmerSettingsSectionHeaderView(title: "PREFERENCES")
                ShimmerSettingsSectionView(itemCount: 5)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                ShimmerSettingsSectionHeaderView(title: "RESTRICTIONS")
                ShimmerSettingsSectionView(itemCount: 2)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                ShimmerSettingsSectionHeaderView(title: "SUPPORT & LEGAL")
                ShimmerSettingsSectionView(itemCount: 4)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                ShimmerSettingsSectionHeaderView(title: "ACCOUNT")
                ShimmerSettingsSectionView(itemCount: 4)
            }
            
            // Delete account button shimmer
            ShimmerView(cornerRadius: 12)
                .frame(height: 56)
                .padding(.bottom, 24)
        }
    }
}

struct ShimmerSettingsSectionHeaderView: View {
    let title: String
    
    var body: some View {
        HStack {
            ShimmerView(cornerRadius: 2)
                .frame(width: CGFloat(title.count * 8), height: 14)
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

struct ShimmerSettingsProfileHeaderView: View {
    var body: some View {
        // Mimic FSCard structure
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 16) {
                // Profile image shimmer - exact same size as real image
                ShimmerView(cornerRadius: 37.5)
                    .frame(width: 75, height: 75)
                
                VStack(alignment: .leading, spacing: 8) {
                    // Status pill shimmer - matching FSPill
                    ShimmerView(cornerRadius: 12)
                        .frame(width: 45, height: 20)
                    
                    // Email shimmer - matching FSTextView
                    ShimmerView(cornerRadius: 2)
                        .frame(width: 160, height: 16)
                }
                Spacer()
            }
            .padding(5) // Same padding as real profileHeader
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .background(Color.white) // FSCard background
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray230, lineWidth: 1)
        )
    }
}

struct ShimmerSettingsSectionView: View {
    let itemCount: Int
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<itemCount, id: \.self) { index in
                ShimmerSettingsRowView()
                if index < itemCount - 1 {
                    Divider()
                }
            }
        }
        .background(Color.gray246)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

struct ShimmerSettingsRowView: View {
    var body: some View {
        HStack {
            // Title shimmer
            ShimmerView(cornerRadius: 2)
                .frame(width: 120, height: 16)
            
            Spacer()
            
            // Value shimmer
            ShimmerView(cornerRadius: 2)
                .frame(width: 60, height: 14)
            
            // Chevron shimmer
            ShimmerView(cornerRadius: 2)
                .frame(width: 8, height: 14)
        }
        .padding() // Same padding as real settingsRow
        .contentShape(Rectangle())
    }
}
