//
//  MonumentViewModel.swift
//  CH2
//
//  Created by Asad Raza on 14/11/25.
//

import SwiftUI
import Combine

class MonumentViewModel : ObservableObject {
    
    @Published var monuments: [Monument] = [
        Monument(name: "Eiffel Tower", country: "France", city: "Paris", description : "Built in 1889 for the Exposition Universelle, the Eiffel Tower is a global icon of France and one of the most recognizable structures in the world. Standing 330 meters tall, it was once the tallest man-made structure and remains a symbol of innovation, romance, and Parisian elegance.", imageName: ["Eiffel1", "Eiffel2", "Eiffel3", "Eiffel4"]),
        Monument(name: "Acropolis of Athens", country: "Greece", city: "Athens", description : "The Acropolis of Athens is an ancient citadel perched above the city, housing historic structures like the Parthenon and Erechtheion. Built in the 5th century BCE, it represents the birthplace of democracy and the artistic achievements of Classical Greece.", imageName: ["Acropolis1",  "Acropolis3", "Acropolis2", "Acropolis4"]),
        Monument(name: "Golden Gate Bridge", country: "USA", city: "San Francisco", description : "Opened in 1937, the Golden Gate Bridge is an engineering marvel and one of the most photographed bridges in the world. Spanning 2.7 kilometers across the Golden Gate Strait, its striking International Orange color and Art Deco design make it an enduring symbol of San Francisco.", imageName: ["Bridge1", "Bridge2", "Bridge3", "Bridge4"]),
        Monument(name: "Sagrada Familia", country: "Spain", city: "Barcelona", description : "Designed by Antoni Gaudí, the Sagrada Família is a breathtaking basilica that has been under construction since 1882. Blending Gothic and Art Nouveau styles, it is a UNESCO World Heritage Site and one of the most extraordinary examples of architectural imagination ever built.", imageName: ["Sagrada1", "Sagrada2", "Sagrada3", "Sagrada4"]),
        Monument(name: "Leaning Tower of Pisa", country: "Italy", city: "Pisa", description : "Famous for its unintended tilt, the Leaning Tower of Pisa is a freestanding bell tower of the cathedral of Pisa. Completed in 1372, its lean is caused by unstable ground beneath its foundation, making it one of Italy’s most photographed landmarks and a masterpiece of medieval engineering.", imageName: ["Pisa1", "Pisa2", "Pisa3", "Pisa4"])
    ]
}
