//
//  Monuments.swift
//  CH2
//
//  Created by Asad Raza on 14/11/25.
//

import Foundation

struct Monument : Identifiable{
    var id: UUID = UUID()
    var name: String
    var country : String
    var city : String
    var description : String
    var imageName: [String]
}
