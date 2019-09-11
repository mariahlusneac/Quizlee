//
//  BreedSectionHeaderViewModel.swift
//  Quizlee
//
//  Created by Maria Hlusneac on 05/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation
struct BreedSectionHeaderViewModel {
    let breedName: String
    
    init(withDog dog: DogTab2) {
        breedName = dog.name
    }
    
}
