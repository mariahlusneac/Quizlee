//
//  DogTableViewCellViewModel.swift
//  Quizlee
//
//  Created by Maria Hlusneac on 05/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation
import UIKit

struct DogTableViewCellViewModel {
    let name: String
    let image: DogImage
    let apiClientDog = DogAPIClient(baseURL: URL(string: "https://dog.ceo/api/")!)
    
    init(withDog dog: DogTab2) {
        name = dog.name
        image = dog.image
    }
    
    
}
