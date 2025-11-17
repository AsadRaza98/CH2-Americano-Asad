//
//  ContainerView.swift
//  CH2
//
//  Created by Asad Raza on 14/11/25.
//

import SwiftUI

struct ContainerView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Camera", systemImage: "camera")
                }
            
            MyMonumentView()
                .tabItem {
                    Label("Monuments", systemImage: "building.columns")
                }
                .tint(Color(red: 0.83, green: 0.71, blue: 0.37)) // 🟡 gold instead of blue
                        // Dark background for the tab bar
                        .background(Color.black.ignoresSafeArea())
        }
    }
}

#Preview {
    ContainerView()
}
