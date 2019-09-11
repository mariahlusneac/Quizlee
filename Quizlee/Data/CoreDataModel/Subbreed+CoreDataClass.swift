//
//  Subbreed+CoreDataClass.swift
//  Quizlee
//
//  Created by Maria Hlusneac on 04/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//
//

import Foundation
import CoreData

protocol SubbreedPropertiesContainer {
    var name: String? { get set }
    var image: String? { get set }
}

@objc(Subbreed)
public class Subbreed: NSManagedObject, SubbreedPropertiesContainer {

}
