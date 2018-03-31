//
//  DataService.swift
//  SW
//
//  Created by Александр on 19.01.2018.
//  Copyright © 2018 Александр. All rights reserved.
//

import Foundation
import CoreData

final class DataService {
    
    static func getDataAndSaveContextChanges() {
        
        let context = CoreDataStack.shared.makePrivateContext()
        
//        SWAPI.shared.getAll(.people) { data in
//            self.perform(in: context) {
//                data .forEach { _ = People.makeOrUpdate(from: $0, in: context) }
//            }
//        }
//
//        SWAPI.shared.getAll(.planets) { data in
//            self.perform(in: context) {
//                data .forEach { _ = Planet.make(from: $0, in: context) }
//            }
//        }
//
//        SWAPI.shared.getAll(.vehicles) { data in
//            self.perform(in: context) {
//                data .forEach { _ = Vehicle.make(from: $0, in: context) }
//            }
//        }
//        
//        SWAPI.shared.getAll(.starships) { data in
//            self.perform(in: context) {
//                data .forEach { _ = StarShip.make(from: $0, in: context) }
//            }
//        }
//        
//        SWAPI.shared.getAll(.species) { data in
//            self.perform(in: context) {
//                data .forEach { _ = Specie.makeOrUpdate(from: $0, in: context) }
//            }
//        }
        
//        let context = CoreDataStack.shared.mainContext
        
        context.perform {
            let request: NSFetchRequest<People> = People.fetchRequest()

            request.predicate = NSPredicate(format: "height > %i", 170)

//            request.sortDescriptors = [
//                NSSortDescriptor(key: #keyPath(People.height), ascending: false),
//                NSSortDescriptor(key: "name", ascending: true)
//            ]
//
//            request.fetchLimit = 10
//            request.fetchOffset = 9

            let result = (try? request.execute()) ?? []

            result
                .forEach { people in
                    (people.species as? Set<Specie>)?.forEach {
                        print(people.name ?? "", $0.name ?? "") } }
        }
    }
    
    
    static private func perform(in context: NSManagedObjectContext, closure: @escaping () -> ()) {
        context.perform {
            closure()
            
            do {
                if context.hasChanges {
                    try context.save()
                    debugPrint("Context changes save")
                }
                else {
                    debugPrint("Context has no changes")
                }
            }
            catch {
                debugPrint(error)
            }
        }
    }
}

