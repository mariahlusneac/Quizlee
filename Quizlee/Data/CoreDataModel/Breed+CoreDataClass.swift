//
//  Breed+CoreDataClass.swift
//  Quizlee
//
//  Created by Maria Hlusneac on 04/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//
//

import Foundation
import CoreData

protocol BreedPropertiesContainer {
    var name: String? { get set }
    var image: String? { get set }
    var hasModel: Array<SubbreedPropertiesContainer>? { get }
}

@objc(Breed)
public class Breed: NSManagedObject, BreedPropertiesContainer {
    
    var hasModel: Array<SubbreedPropertiesContainer>? {
        return (has?.allObjects as? [SubbreedPropertiesContainer])
    }
    
    
    

}
