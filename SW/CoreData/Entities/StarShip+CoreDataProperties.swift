//
//  StarShip+CoreDataProperties.swift
//  SW
//
//  Created by Александр on 01.02.2018.
//  Copyright © 2018 Александр. All rights reserved.
//
//

import Foundation
import CoreData


extension StarShip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StarShip> {
        return NSFetchRequest<StarShip>(entityName: "StarShip")
    }

    @NSManaged public var hyperDriveRating: Float
    @NSManaged public var mglt: Int16
    @NSManaged public var starshipClass: String?
    @NSManaged public var pilots: NSSet?

}

// MARK: Generated accessors for pilots
extension StarShip {

    @objc(addPilotsObject:)
    @NSManaged public func addToPilots(_ value: People)

    @objc(removePilotsObject:)
    @NSManaged public func removeFromPilots(_ value: People)

    @objc(addPilots:)
    @NSManaged public func addToPilots(_ values: NSSet)

    @objc(removePilots:)
    @NSManaged public func removeFromPilots(_ values: NSSet)

}
