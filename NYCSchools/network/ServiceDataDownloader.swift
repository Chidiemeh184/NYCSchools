//
//  ServiceDataDownloader.swift
//  NYCSchools
//
//  Created by Chidi Emeh on 1/12/19.
//  Copyright © 2019 Chidi Emeh. All rights reserved.
//

import UIKit
import CoreData

class ServiceDataDownloader {
    
    var context: NSManagedObjectContext!
    
    init(context: NSManagedObjectContext) {
        self.context = context
        deleteRecords()
    }
    
    let schools = "https://data.cityofnewyork.us/resource/97mf-9njv.json"
    let scores = "https://data.cityofnewyork.us/resource/734v-jeq5.json"
    
    func loadData( completionHandler: @escaping (Bool) -> Void) {
        let  schoolManagedObjectContext = CoreDataStack().persistentContainer.viewContext
        let networkService = NetworkService(managedObjectContext: schoolManagedObjectContext)
        _ = networkService.loadSchoolsData(from: self.schools) { response in
            switch response {
            case .sucess(let nycschools):
                print(nycschools[0])
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        let scoreManagedObjectContext = CoreDataStack().persistentContainer.viewContext
        let scoresService = NetworkService(managedObjectContext: scoreManagedObjectContext)
        _ = scoresService.loadScoresData(from: self.scores) { response in
            switch response {
            case .sucess(let satscores):
                print(satscores[0])
                completionHandler(true)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteRecords() {
        let schoolRequest: NSFetchRequest<School> = School.fetchRequest()
        let scoreRequest: NSFetchRequest<SATScore> = SATScore.fetchRequest()
        var deleteRequest: NSBatchDeleteRequest
        var deleteResults: NSPersistentStoreResult
        do {
            deleteRequest = NSBatchDeleteRequest(fetchRequest: schoolRequest as! NSFetchRequest<NSFetchRequestResult>)
            deleteResults = try context.execute(deleteRequest)
            
            deleteRequest = NSBatchDeleteRequest(fetchRequest: scoreRequest as! NSFetchRequest<NSFetchRequestResult>)
            deleteResults = try context.execute(deleteRequest)
        }
        catch {
            fatalError("Failed removing existing records")
        }
    }
}
