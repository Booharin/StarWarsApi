//
//  CoreDataStack.swift
//  SW
//
//  Created by Александр on 19.01.2018.
//  Copyright © 2018 Александр. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataStack {
    
    private(set) static var shared: CoreDataStack = {
        return CoreDataStack()
    }()
    
    private let storeIsReady = DispatchGroup()
    
    private let modelName: String
    private let storeName: String
    
    lazy var mainContext: NSManagedObjectContext = {
       storeIsReady.wait()
        
        return DispatchQueue.anywayOnMain {
            let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            context.persistentStoreCoordinator = coordinator
            return context
        }
    }()
    
    private lazy var coordinator: NSPersistentStoreCoordinator = {
        NSPersistentStoreCoordinator(managedObjectModel: objectModel)
    }()
    
    private lazy var objectModel: NSManagedObjectModel = {
        guard let model = NSManagedObjectModel(contentsOf: objectModelUrl) else {
            fatalError("Error initializing mom from: \(modelName)")
        }
        return model
    }()
    
    private lazy var objectModelUrl: URL = {
        guard let url = Bundle.main.url(forResource: modelName, withExtension: "momd") else {
            fatalError("Error loading model from bundle")
        }
        
        return url
    }()
    
    private lazy var documenstUrl: URL = {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            fatalError("Unable te resolve document directory")
        }
        
        return url
    }()
    
    init(modelName: String = "SW", storeName: String = "SW.sqlite") {
        self.modelName = modelName
        self.storeName = storeName
        registerStore()
    }
    
    func makePrivateContext() -> NSManagedObjectContext {
        storeIsReady.wait()
        
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        return context
    }
    
    func saveToStore() {
        storeIsReady.wait()
        
        DispatchQueue.anywayOnMain {
            guard mainContext.hasChanges else {
                debugPrint("Data has not changes")
                return
            }
            do {
                try mainContext.save()
                debugPrint("Data succesfully saved to store")
            }
            catch {
                debugPrint("Data not saved to store with error \(error)")
            }
        }
    }
    
    private func registerStore() {
        
        storeIsReady.enter()
        
        DispatchQueue.global(qos: .background).async {
            let storeUrl = self.documenstUrl.appendingPathComponent(self.storeName)
            
            // MARK: Options for migration with automatioc mapping & migration of persistent store
            
            let storeOptions = [
                NSInferMappingModelAutomaticallyOption: true,
                NSMigratePersistentStoresAutomaticallyOption: true
            ]
            
            do {
                try self.coordinator.addPersistentStore(
                    ofType: NSSQLiteStoreType,
                    configurationName: nil,
                    at: storeUrl,
                    options: storeOptions
                )
                
                self.storeIsReady.leave()
            }
            catch {
                print("Error creat store \(error)")
                //fatalError("Error creat store \(error)")
            }
        }
    }
}
