//
//  CoreDataStack.swift
//  NYCSchools
//
//  Created by Chidi Emeh on 1/7/19.
//  Copyright © 2019 Chidi Emeh. All rights reserved.
//

import Foundation
import CoreData

open class CoreDataStack {
    public init() {
    }
    static let shared = CoreDataStack()
    
    public lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NYCSchools")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Error loading Persistent Container: \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Error saving ViewContext: \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
