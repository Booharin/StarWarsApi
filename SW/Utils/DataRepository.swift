import Foundation
import CoreData

final class DataRepository {
    private let storage: CoreDataStack
    private let api: SWAPI
    
    static let shared: DataRepository = {
        return DataRepository(
            storage: CoreDataStack.shared,
            api: SWAPI.shared
        )
    }()
    
    init(storage: CoreDataStack, api: SWAPI) {
        self.storage = storage
        self.api = api
    }
    
    func fetchAll(for modelType: ModelType, forceReload: Bool = true, completion: (() -> ())? = nil) {
        let context = storage.makePrivateContext()
        
        context.perform {
            let modelClass = self.getClass(for: modelType)
            let resultsIsEmpty = (try? modelClass?.fetchRequest().execute().isEmpty ?? true) ?? true
            
            guard resultsIsEmpty || forceReload else {
                completion?()
                return
            }
            
            self.api.getAll(modelType) { data in
                self.perform(
                    in: context,
                    clousure: { data.forEach { _ = modelClass?.makeOrUpdate(from: $0, in: context) } },
                    completion: completion
                )
            }
        }
    }
    
    func fetchPeople(with id: Int16, completion: @escaping (People) -> ()) {
        let context = storage.makePrivateContext()

        context.perform {
            do {
                let request: NSFetchRequest<People> = People.fetchRequest()
                request.predicate = NSPredicate(format: "id = %u", id)
                
                var people = try request.execute().first
                
                if people == nil {
                    let data = try self.api.get(.people, withId: id.toInt)
                    people = People.makeOrUpdate(from: data, in: context)
                }
                
                if let homeworldId = people?.homeworldId, people?.homeworld == nil {
                    _ = Planet.makeOrUpdate(
                        from: try self.api.get(.planets, withId: homeworldId.toInt),
                        in: context
                    )
                }
                
                if let ids = people?.specieIds, people?.species?.count == 0 {
                    try ids.forEach {
                        _ = Specie.makeOrUpdate(
                            from: try self.api.get(.species, withId: $0),
                            in: context
                        )
                    }
                }
                
                if let ids = people?.starshipIds, people?.starships?.count == 0 {
                    try ids.forEach {
                        _ = StarShip.makeOrUpdate(
                            from: try self.api.get(.starships, withId: $0),
                            in: context
                        )
                    }
                }
                
                if let ids = people?.vehicleIds, people?.vehicles?.count == 0 {
                    try ids.forEach {
                        _ = Vehicle.makeOrUpdate(
                            from: try self.api.get(.vehicles, withId: $0),
                            in: context
                        )
                    }
                }
                
                try context.save()
                
                guard let unwrapped = people else { return }
                completion(unwrapped)
            }
            catch {
                debugPrint("Can't fetch people with id \(id)")
            }
        }
    }
    
    func fetchStarship(with id: Int16, completion: @escaping (StarShip) -> ()) {
        let context = storage.makePrivateContext()
        
        context.perform {
            do {
                let request: NSFetchRequest<StarShip> = StarShip.fetchRequest()
                request.predicate = NSPredicate(format: "id = %u", id)
                
                var starship = try request.execute().first
                
                if starship == nil {
                    let data = try self.api.get(.starships, withId: id.toInt)
                    starship = StarShip.makeOrUpdate(from: data, in: context)
                }
                
                if let ids = starship?.pilotIds, starship?.pilots?.count == 0 {
                    try ids.forEach {
                        _ = People.makeOrUpdate(
                            from: try self.api.get(.people, withId: $0),
                            in: context
                        )
                    }
                }
                
                try context.save()
                
                guard let unwrapped = starship else { return }
                completion(unwrapped)
            }
            catch {
                debugPrint("Can't fetch starship with id \(id)")
            }
        }
    }
    
    func fetchPlanet(with id: Int16, completion: @escaping (Planet) -> ()) {
        let context = storage.makePrivateContext()
        
        context.perform {
            do {
                let request: NSFetchRequest<Planet> = Planet.fetchRequest()
                request.predicate = NSPredicate(format: "id = %u", id)
                
                var planet = try request.execute().first
                
                if planet == nil {
                    let data = try self.api.get(.planets, withId: id.toInt)
                    planet = Planet.makeOrUpdate(from: data, in: context)
                }

                if let ids = planet?.residentIds, planet?.residents?.count == 0 {
                    try ids.forEach {
                        _ = People.makeOrUpdate(
                            from: try self.api.get(.people, withId: $0),
                            in: context
                        )
                    }
                }
                
                try context.save()
                
                guard let unwrapped = planet else { return }
                completion(unwrapped)
            }
            catch {
                debugPrint("Can't fetch planet with id \(id)")
            }
        }
    }
    
    func fetchSpecie(with id: Int16, completion: @escaping (Specie) -> ()) {
        let context = storage.makePrivateContext()
        
        context.perform {
            do {
                let request: NSFetchRequest<Specie> = Specie.fetchRequest()
                request.predicate = NSPredicate(format: "id = %u", id)
                
                var specie = try request.execute().first
                
                if specie == nil {
                    let data = try self.api.get(.species, withId: id.toInt)
                    specie = Specie.makeOrUpdate(from: data, in: context)
                }
                
                if let homeworldId = specie?.homeworldId, specie?.homeworld == nil {
                    _ = Planet.makeOrUpdate(
                        from: try self.api.get(.planets, withId: homeworldId.toInt),
                        in: context
                    )
                }

                if let ids = specie?.peopleIds, specie?.people?.count == 0 {
                    try ids.forEach {
                        _ = People.makeOrUpdate(
                            from: try self.api.get(.people, withId: $0),
                            in: context
                        )
                    }
                }
                
                try context.save()
                
                guard let unwrapped = specie else { return }
                completion(unwrapped)
            }
            catch {
                debugPrint("Can't fetch specie with id \(id)")
            }
        }
    }
    
    func fetchVehicle(with id: Int16, completion: @escaping (Vehicle) -> ()) {
        let context = storage.makePrivateContext()
        
        context.perform {
            do {
                let request: NSFetchRequest<Vehicle> = Vehicle.fetchRequest()
                request.predicate = NSPredicate(format: "id = %u", id)
                
                var vehicle = try request.execute().first
                
                if vehicle == nil {
                    let data = try self.api.get(.vehicles, withId: id.toInt)
                    vehicle = Vehicle.makeOrUpdate(from: data, in: context)
                }
                
                if let ids = vehicle?.pilotIds, vehicle?.pilots?.count == 0 {
                    try ids.forEach {
                        _ = People.makeOrUpdate(
                            from: try self.api.get(.people, withId: $0),
                            in: context
                        )
                    }
                }

                try context.save()
                
                guard let unwrapped = vehicle else { return }
                completion(unwrapped)
            }
            catch {
                debugPrint("Can't fetch vehicle with id \(id)")
            }
        }
    }
    
    func getClass(for modelType: ModelType) -> ManagedCoreDataModel.Type? {
        switch modelType {
        case .people:
            return People.self
        case .films:
            return nil
        case .planets:
            return Planet.self
        case .species:
            return Specie.self
        case .starships:
            return StarShip.self
        case .vehicles:
            return Vehicle.self
        }
    }
    
    private func perform(in context: NSManagedObjectContext, clousure: @escaping () -> (), completion: (() -> ())? = nil) {
        context.perform {
            defer { completion? () }
            clousure()
            
            do {
                if context.hasChanges {
                    try context.save()
                    self.storage.saveToStore()
                    debugPrint("Context changes saved")
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
    
    private func performAndWait(in context: NSManagedObjectContext, clousure: @escaping () -> (), completion: (() -> ())? = nil) {
        context.performAndWait {
            defer { completion? () }
            clousure()
            
            do {
                if context.hasChanges {
                    try context.save()
                    self.storage.saveToStore()
                    debugPrint("Context changes saved")
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

typealias ManagedCoreDataModel = NSManagedObject & CoreDataModel

protocol CoreDataModel {
    static func makeOrUpdate(from json: JSON, in context: NSManagedObjectContext) -> Self?
}

extension People: CoreDataModel {}
extension Planet: CoreDataModel {}
extension Specie: CoreDataModel {}
extension StarShip: CoreDataModel {}
extension Vehicle: CoreDataModel {}
