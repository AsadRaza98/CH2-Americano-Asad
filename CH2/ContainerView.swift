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
        }
    }
}

#Preview {
    ContainerView()
}
