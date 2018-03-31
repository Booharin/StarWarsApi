//
//  Vehicle+CoreDataClass.swift
//  SW
//
//  Created by Александр on 22.01.2018.
//  Copyright © 2018 Александр. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Vehicle)
public final class Vehicle: AbstractVehicle {
    
    class func makeOrUpdate(from json: JSON, in context: NSManagedObjectContext) -> Vehicle? {
        guard let objectId = json["url"].url?.lastPathComponent.asInt16 else { return nil }
        let object = getUniqueInstance(from: objectId, in: context)
        
        object.name = json["name"].string
        object.id = objectId
        object.created = Date.fromISO8601(json["created"].stringValue) as NSDate?
        object.edited = Date.fromISO8601(json["edited"].stringValue) as NSDate?
        object.model = json["model"].string
        
        object.vehicleClass = json["vehicle_class"].string
        object.manufacturer = json["manufacturer"].string
        object.cost = json["cost_in_credits"].int64 ?? -1
        object.length = json["length"].float ?? -1
        object.maxAtmospheringSpeed = json["max_atmosphering_speed"].int64 ?? -1
        object.crew = json["crew"].int64 ?? -1
        object.passengers = json["passengers"].int64 ?? -1
        object.cargoCapacity = json["cargo_capacity"].int64 ?? -1
        object.consumables = json["consumables"].string
        object.pilotIds = json["pilots"].array?.compactMap { $0.url?.lastPathComponent.asInt }
        object.filmIds = json["films"].array?.compactMap { $0.url?.lastPathComponent.asInt }
        
        object.updateRelationships()
        
        return object
    }
    
    private static func getUniqueInstance(from id: Int16, in context: NSManagedObjectContext) -> Vehicle {
        typealias Entity = Vehicle
        
        let request: NSFetchRequest<Entity> = fetchRequest()
        request.predicate = NSPredicate(format: "id = %i", id)
        
        let results = try? request.execute()
        
        guard let exidted = results?.first else {
            debugPrint("Object created: \(Entity.self) \(id)")
            return Entity(entity: entity(), insertInto: context)
        }
        
        return exidted
    }
    
    private func updateRelationships() {
        updatePilotsRelationship()
    }
    
    private func updatePilotsRelationship() {
        typealias Entity = People
        
        let request: NSFetchRequest<Entity> = Entity.fetchRequest()
        
        do {
            try request.execute()
                .filter {
                    let shouldBinded = $0.vehicleIds?.contains(id.toInt) == true
                    let notBinded = ($0.vehicles as? Set<Vehicle>)?.first { $0.id == id } == nil
                    return shouldBinded && notBinded
                }
                .forEach {
                    $0.addToVehicles(self)
                    debugPrint("Make relationship \(type(of: self)) (\(name ?? ""))) <=> \(type(of: $0)) (\($0.name ?? ""))")
            }
        }
        catch {
            debugPrint("Could not make relationship \(type(of: self)) <=> \(Entity.self))")
        }
    }
}

