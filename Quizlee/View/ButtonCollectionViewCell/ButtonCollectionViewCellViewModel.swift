//
//  ButtonCollectionViewCellViewModel.swift
//  Quizlee
//
//  Created by Maria Hlusneac on 05/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation

struct ButtonCollectionViewCellViewModel {
    let characTraitString: String!
    
    init(with characTrait: CharacTrait) {
        characTraitString = characTrait.name
    }
}
