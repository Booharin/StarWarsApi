//
//  People+CoreDataProperties.swift
//  SW
//
//  Created by Александр on 02.02.2018.
//  Copyright © 2018 Александр. All rights reserved.
//
//

import Foundation
import CoreData


extension People {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<People> {
        return NSFetchRequest<People>(entityName: "People")
    }

    @NSManaged public var birthYear: String?
    @NSManaged public var created: NSDate?
    @NSManaged public var edited: NSDate?
    @NSManaged public var eyeColor: String?
    @NSManaged public var filmIds: [Int]?
    @NSManaged public var gender: String?
    @NSManaged public var hairColor: String?
    @NSManaged public var height: Int16
    @NSManaged public var homeworldId: Int16
    @NSManaged public var id: Int16
    @NSManaged public var mass: Int16
    @NSManaged public var name: String?
    @NSManaged public var skinColor: String?
    @NSManaged public var specieIds: [Int]?
    @NSManaged public var starshipIds: [Int]?
    @NSManaged public var vehicleIds: [Int]?
    @NSManaged public var homeworld: Planet?
    @NSManaged public var species: NSSet?
    @NSManaged public var starships: NSSet?
    @NSManaged public var vehicles: NSSet?

}

// MARK: Generated accessors for species
extension People {

    @objc(addSpeciesObject:)
    @NSManaged public func addToSpecies(_ value: Specie)

    @objc(removeSpeciesObject:)
    @NSManaged public func removeFromSpecies(_ value: Specie)

    @objc(addSpecies:)
    @NSManaged public func addToSpecies(_ values: NSSet)

    @objc(removeSpecies:)
    @NSManaged public func removeFromSpecies(_ values: NSSet)

}

// MARK: Generated accessors for starships
extension People {

    @objc(addStarshipsObject:)
    @NSManaged public func addToStarships(_ value: StarShip)

    @objc(removeStarshipsObject:)
    @NSManaged public func removeFromStarships(_ value: StarShip)

    @objc(addStarships:)
    @NSManaged public func addToStarships(_ values: NSSet)

    @objc(removeStarships:)
    @NSManaged public func removeFromStarships(_ values: NSSet)

}

// MARK: Generated accessors for vehicles
extension People {

    @objc(addVehiclesObject:)
    @NSManaged public func addToVehicles(_ value: Vehicle)

    @objc(removeVehiclesObject:)
    @NSManaged public func removeFromVehicles(_ value: Vehicle)

    @objc(addVehicles:)
    @NSManaged public func addToVehicles(_ values: NSSet)

    @objc(removeVehicles:)
    @NSManaged public func removeFromVehicles(_ values: NSSet)

}
