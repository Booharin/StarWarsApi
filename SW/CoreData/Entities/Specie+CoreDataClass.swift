//
//  Specie+CoreDataClass.swift
//  SW
//
//  Created by Александр on 19.01.2018.
//  Copyright © 2018 Александр. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Specie)
public final class Specie: NSManagedObject {
    
    static func makeOrUpdate(from json: JSON, in context: NSManagedObjectContext) -> Specie? {
        guard let objectId = json["url"].url?.lastPathComponent.asInt16 else { return nil }
        
        let object = getUniqueInstance(from: objectId, in: context)
        
        object.name = json["name"].string
        object.id = objectId
        object.created = Date.fromISO8601(json["created"].stringValue) as NSDate?
        object.edited = Date.fromISO8601(json["edited"].stringValue) as NSDate?
        
        object.classification = json["classification"].string
        object.designation = json["designation"].string
        object.averageHeight = json["average_height"].int16 ?? -1
        object.skinColors = json["skin_colors"].string
        object.hairColors = json["hair_colors"].string
        object.eyeColors = json["eye_colors"].string
        object.homeworldId = json["homeworld"].url?.lastPathComponent.asInt16 ?? -1
        object.averageLifespan = json["average_lifespan"].int16 ?? -1
        object.language = json["language"].string
        object.peopleIds = json["people"].array?.compactMap { $0.url?.lastPathComponent.asInt }
        object.filmIds = json["films"].array?.compactMap { $0.url?.lastPathComponent.asInt }
        
        object.updateRelationships()
        
        return object
    }
    
    private static func getUniqueInstance(from id: Int16, in context: NSManagedObjectContext) -> Specie {
        typealias Entity = Specie
        
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
        updatePeopleRelationships()
    }
    
    private func updatePeopleRelationships() {
        typealias Entity = People
        
        let request: NSFetchRequest<Entity> = Entity.fetchRequest()
        
        do {
            try request.execute()
                .filter {
                    let shouldBinded = $0.specieIds?.contains(id.toInt) == true
                    let notBinded = ($0.species as? Set<Specie>)?.first { $0.id == id } == nil
                    return shouldBinded && notBinded
                }
                .forEach {
                    $0.addToSpecies(self)
                    debugPrint("Make relationship \(type(of: self)) (\(name ?? ""))) <=> \(type(of: $0)) (\($0.name ?? ""))")
            }
        }
        catch {
            debugPrint("Could not make relationship \(type(of: self)) <=> \(Entity.self))")
        }
    }
}
