//
//  Dog.swift
//  Quizlee
//
//  Created by Maria Hlusneac on 07/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation

struct DogBreed {
    var dogBreed: String
    var dogSubbreeds: [String]
    
    init(dogBreed: String, dogSubbreeds: [String]) {
        self.dogBreed = dogBreed
        self.dogSubbreeds = dogSubbreeds
    }
}
