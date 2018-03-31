//
//  Specie+CoreDataProperties.swift
//  SW
//
//  Created by Александр on 01.02.2018.
//  Copyright © 2018 Александр. All rights reserved.
//
//

import Foundation
import CoreData


extension Specie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Specie> {
        return NSFetchRequest<Specie>(entityName: "Specie")
    }

    @NSManaged public var averageHeight: Int16
    @NSManaged public var averageLifespan: Int16
    @NSManaged public var classification: String?
    @NSManaged public var created: NSDate?
    @NSManaged public var designation: String?
    @NSManaged public var edited: NSDate?
    @NSManaged public var eyeColors: String?
    @NSManaged public var filmIds: [Int]?
    @NSManaged public var hairColors: String?
    @NSManaged public var homeworldId: Int16
    @NSManaged public var id: Int16
    @NSManaged public var language: String?
    @NSManaged public var name: String?
    @NSManaged public var peopleIds: [Int]?
    @NSManaged public var skinColors: String?
    @NSManaged public var homeworld: Planet?
    @NSManaged public var people: NSSet?

}

// MARK: Generated accessors for people
extension Specie {

    @objc(addPeopleObject:)
    @NSManaged public func addToPeople(_ value: People)

    @objc(removePeopleObject:)
    @NSManaged public func removeFromPeople(_ value: People)

    @objc(addPeople:)
    @NSManaged public func addToPeople(_ values: NSSet)

    @objc(removePeople:)
    @NSManaged public func removeFromPeople(_ values: NSSet)

}
