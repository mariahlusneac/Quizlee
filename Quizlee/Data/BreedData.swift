//
//  BreedData.swift
//  Quizlee
//
//  Created by Maria Hlusneac on 02/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation

public class BreedData {
    
    let breedName: String
    
    let apiClientDog = DogAPIClient.sharedInstance
    var breeds = Breeds()
    var allDogsObtained: [String]
    
    var randomInt = 0
    
    init() {
        allDogsObtained = breeds.allDogsObtained
        randomInt = Int(arc4random_uniform(UInt32(allDogsObtained.count)))
        breedName = allDogsObtained[randomInt]
    }
}
