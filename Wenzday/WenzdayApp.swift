//
//  WenzdayApp.swift
//  Wenzday
//
//  Created by yuxiang on 2025/6/17.
//

import SwiftUI

@main
struct WenzdayApp: App {
    @State private var selectedTab = 0 // Default to Allowance tab for testing

    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                AllowanceView()
                    .tabItem {
                        Label("Allowance", systemImage: "dollarsign.circle")
                    }
                    .tag(0)

                ChartsView()
                    .tabItem {
                        Label("Charts", systemImage: "chart.bar")
                    }
                    .tag(1)

                LoreneView()
                    .tabItem {
                        Label("Lorene", systemImage: "person.crop.circle")
                    }
                    .tag(2)
            }
            .accentColor(.blue)
            .onAppear {
                // 设置 tab bar 样式
                let appearance = UITabBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = UIColor.systemBackground
                appearance.shadowColor = UIColor.systemGray4

                UITabBar.appearance().standardAppearance = appearance
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
    }
}
