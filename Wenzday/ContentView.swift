//
//  ContentView.swift
//  Wenzday
//
//  Created by yuxiang on 2025/6/17.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "calendar")
                .font(.system(size: 60))
                .foregroundStyle(.blue)
            Text("Welcome to Wenzday!")
                .font(.title)
                .bold()
            Button("Count Down to Wenzday") {
                print("Button tapped")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
