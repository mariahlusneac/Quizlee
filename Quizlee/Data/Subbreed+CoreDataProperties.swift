//
//  Subbreed+CoreDataProperties.swift
//  Quizlee
//
//  Created by Maria Hlusneac on 12/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//
//

import Foundation
import CoreData


extension Subbreed {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Subbreed> {
        return NSFetchRequest<Subbreed>(entityName: "Subbreed")
    }

    @NSManaged public var name: String?
    @NSManaged public var image: NSData?
    @NSManaged public var owner: Breed?

}
