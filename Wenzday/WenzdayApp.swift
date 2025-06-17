//
//  WenzdayApp.swift
//  Wenzday
//
//  Created by yuxiang on 2025/6/17.
//

import SwiftUI

@main
struct WenzdayApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                AllowanceView()
                    .tabItem {
                        Label("Allowance", systemImage: "dollarsign.circle")
                    }

                ChartsView()
                    .tabItem {
                        Label("Charts", systemImage: "chart.bar")
                    }

                LoreneView()
                    .tabItem {
                        Label("Lorene", systemImage: "person.crop.circle")
                    }
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
