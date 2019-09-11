//
//  DogCollectionViewCellViewModel.swift
//  Quizlee
//
//  Created by Maria Hlusneac on 05/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation

class DogCollectionViewCellViewModel {
    let dogNameString: String!
    
    init(withDog dog: DogTab1) {
        dogNameString = dog.name
    }
}
