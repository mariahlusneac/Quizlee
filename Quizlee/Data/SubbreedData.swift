//
//  SubbreedData.swift
//  Quizlee
//
//  Created by Maria Hlusneac on 02/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation

public class SubbreedData {
    var subbreedName: String
    let breedName = ""
    
    let apiClientDog = DogAPIClient.sharedInstance
    var allDogsObtained = [DogBreed]()
    
    var subbreeds = Subbreeds()
    
    var randomInt = 0
    
    
    init(breedName: String) {
        var initialized = false
        var breedIndex = 0
        allDogsObtained = subbreeds.allDogsObtained
        
        for index in 0..<allDogsObtained.count {
            if allDogsObtained[index].dogBreed == breedName {
                randomInt = Int(arc4random_uniform(UInt32(allDogsObtained[index].dogSubbreeds.count)))
                subbreedName = allDogsObtained[index].dogSubbreeds[randomInt]
                breedIndex = index
                initialized = true
            }
        }
        
        if initialized == false {
            subbreedName = "inexistent"
        }
        else {
            subbreedName = allDogsObtained[breedIndex].dogSubbreeds[randomInt]
        }
    }
    
}
