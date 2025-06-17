//
//  ChartsView.swift
//  Wenzday
//
//  Created by yuxiang on 2025/6/17.
//

import SwiftUI

struct ChartsView: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.2)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 24) {
                    // Header card
                    VStack(spacing: 16) {
                        Image(systemName: "chart.bar.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(.blue)

                        Text("Analytics & Charts")
                            .font(.title2)
                            .fontWeight(.semibold)

                        Text("Visualize your data and trends")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.regularMaterial)
                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    )

                    Spacer()

                    // Feature placeholder
                    Text("Coming Soon...")
                        .font(.caption)
                        .foregroundStyle(.tertiary)

                    Spacer()
                }
                .padding(.horizontal, 20)
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}
