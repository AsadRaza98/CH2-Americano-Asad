//
//  MonumentView.swift
//  CH2
//
//  Created by Asad Raza on 14/11/25.
//

import SwiftUI

struct MonumentView: View {
    var monument : Monument
    
    var body: some View {
        Text(monument.name)
            .font(.largeTitle)
        Image(monument.imageName[0]).resizable()
        Text(monument.country)
        Text(monument.city)
        Image(monument.imageName[1]).resizable()
        Text(monument.description)
        Image(monument.imageName[2]).resizable()
        
    }
}

//#Preview {
//    MonumentView()
//}
