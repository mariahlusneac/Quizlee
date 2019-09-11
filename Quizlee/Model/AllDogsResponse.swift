//
//  AllDogsResponse.swift
//  Quizlee
//
//  Created by Maria Hlusneac on 19/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation

//typealias Breed = String
//typealias Subbreed = String

struct AllDogsResponse: Codable {
    let message: [String: [String]]
}
