//
//  AppDelegate.swift
//  SW
//
//  Created by Александр on 15.01.2018.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
       // DataService.getDataAndSaveContextChanges()
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataStack.shared.saveToStore()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        CoreDataStack.shared.saveToStore()
    }
    
}

