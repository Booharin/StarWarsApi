//
//  Planet+CoreDataClass.swift
//  SW
//
//  Created by Александр on 22.01.2018.
//  Copyright © 2018 Александр. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Planet)
public final class Planet: NSManagedObject {
    
    static func makeOrUpdate(from json: JSON, in context: NSManagedObjectContext) -> Planet? {
        guard let objectId = json["url"].url?.lastPathComponent.asInt16 else { return nil }
        let object = getUniqueInstance(from: objectId, in: context)
        
        object.name = json["name"].string
        object.id = objectId
        object.created = Date.fromISO8601(json["created"].stringValue) as NSDate?
        object.edited = Date.fromISO8601(json["edited"].stringValue) as NSDate?
        
        object.rotationPeriod = json["rotation_period"].int16 ?? -1
        object.orbitalPeriod = json["orbital_period"].int16 ?? -1
        object.diameter = json["diameter"].int32 ?? -1
        object.climate = json["climate"].string
        object.gravity = json["gravity"].string
        object.terrain = json["terrain"].string
        object.surfaceWater = json["surface_water"].int16 ?? -1
        object.population = json["population"].int64 ?? -1
        object.residentIds = json["residents"].array?.compactMap { $0.url?.lastPathComponent.asInt }
        object.filmIds = json["films"].array?.compactMap { $0.url?.lastPathComponent.asInt }
        
        object.updateRelationships()
        
        return object
    }
    
    private static func getUniqueInstance(from id: Int16, in context: NSManagedObjectContext) -> Planet {
        typealias Entity = Planet
        
        let request: NSFetchRequest<Entity> = fetchRequest()
        request.predicate = NSPredicate(format: "id = %i", id)
        
        let results = try? request.execute()
        
        guard let exidted = results?.first else {
            debugPrint("Object created: \(Entity.self) \(id)")
            return Entity(entity: entity(), insertInto: context)
        }
        
        return exidted
    }
    
    func updateRelationships() {
        updateResidentsRelationship()
        updateSpecieRelationship()
    }
    
    private func updateResidentsRelationship() {
        typealias Entity = People
        
        let request: NSFetchRequest<Entity> = Entity.fetchRequest()
        
        do {
            try request.execute()
                .filter {
                    let shouldBinded = $0.homeworldId == id
                    let notBinded = $0.homeworld  == nil
                    return shouldBinded && notBinded
                }
                .forEach {
                    $0.homeworld = self
                    debugPrint("Make relationship \(type(of: self)) (\(name ?? ""))) <=> \(type(of: $0)) (\($0.name ?? ""))")
            }
        }
        catch {
            debugPrint("Could not make relationship \(type(of: self)) <=> \(Entity.self))")
        }
    }
    
    private func updateSpecieRelationship() {
        typealias Entity = Specie
        
        let request: NSFetchRequest<Entity> = Entity.fetchRequest()
        
        do {
            try request.execute()
                .filter {
                    let shouldBinded = $0.homeworldId == id
                    let notBinded = $0.homeworld  == nil
                    return shouldBinded && notBinded
                }
                .forEach {
                    $0.homeworld = self
                    debugPrint("Make relationship \(type(of: self)) (\(name ?? ""))) <= \(type(of: $0)) (\($0.name ?? ""))")
            }
        }
        catch {
            debugPrint("Could not make relationship \(type(of: self)) <=> \(Entity.self))")
        }
    }
}

