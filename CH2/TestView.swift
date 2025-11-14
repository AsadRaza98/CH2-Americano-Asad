//
//  TestView.swift
//  CH2
//
//  Created by Asad Raza on 14/11/25.
//

import SwiftUI

struct MyMonumentView: View {
    @StateObject private var monumentviewmodel = MonumentViewModel()
    var body: some View {
        VStack{
            Text("My Monuments")
                .font(Font.largeTitle)
                .padding()
            
            Spacer()
            
            NavigationStack {
                ScrollView(.horizontal) {
                    HStack{
                        ForEach(monumentviewmodel.monuments) { monument in
                            
                            NavigationLink(destination: MonumentView(monument: monument)) {
                                Image(monument.imageName[0])
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                Text(monument.name)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    MyMonumentView()
}
