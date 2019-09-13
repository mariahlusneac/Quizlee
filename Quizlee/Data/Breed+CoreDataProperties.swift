//
//  Breed+CoreDataProperties.swift
//  Quizlee
//
//  Created by Maria Hlusneac on 12/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//
//

import Foundation
import CoreData


extension Breed {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Breed> {
        return NSFetchRequest<Breed>(entityName: "Breed")
    }

    @NSManaged public var name: String?
    @NSManaged public var image: NSData?
    @NSManaged public var has: NSSet?

}

// MARK: Generated accessors for has
extension Breed {

    @objc(addHasObject:)
    @NSManaged public func addToHas(_ value: Subbreed)

    @objc(removeHasObject:)
    @NSManaged public func removeFromHas(_ value: Subbreed)

    @objc(addHas:)
    @NSManaged public func addToHas(_ values: NSSet)

    @objc(removeHas:)
    @NSManaged public func removeFromHas(_ values: NSSet)

}
