//
//  DataProvider.swift
//  NYCSchools
//
//  Created by Chidi Emeh on 1/13/19.
//  Copyright © 2019 Chidi Emeh. All rights reserved.
//

import Foundation
import CoreData

class DataProvider {
    
    private var persistentContainer: NSPersistentContainer!
    private var repository: NetworkService!
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(persistentContainer: NSPersistentContainer, repository: NetworkService) {
        self.persistentContainer = persistentContainer
        self.repository = repository
    }
    
    func fetchData(completion: @escaping(Error?) -> Void) {
        let schoolUrl =  "https://data.cityofnewyork.us/resource/97mf-9njv.json"
        repository.loadSchoolsData(from: schoolUrl) { (result) in
            switch result {
            case .failure(let error):
                completion(error)
                return
            case .sucess(let schoolsList):
                let scoresUrl = "https://data.cityofnewyork.us/resource/734v-jeq5.json"
                
                self.repository.loadScoresData(from: scoresUrl, completionHandler: { (result) in
                    switch result {
                    case .failure(let error):
                        completion(error)
                        return
                    case .sucess(let scoresList):
                        let taskContext = self.persistentContainer.newBackgroundContext()
                        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                        taskContext.undoManager = nil
                        
                        _ = self.syncDownloadedData(with: schoolsList, scores: scoresList, for: taskContext)
                        
                        completion(nil)
                        return
                    }
                })
                
                return
            }
        }
    }
    
    private func syncDownloadedData(with schools: [SchoolCodbl], scores: [SATScoreCodbl], for context: NSManagedObjectContext) -> Bool {
        
        var isSuccesful = false
        
        context.performAndWait {
            // Batch Delete
            let matchingSchoolsRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "School")
            let schoolDbns = schools.map { $0.dbn }.compactMap { $0 }
            matchingSchoolsRequest.predicate = NSPredicate(format: "dbn in %@", argumentArray: [schoolDbns])
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: matchingSchoolsRequest)
            batchDeleteRequest.resultType = .resultTypeObjectIDs
            
            let matchingScoresRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SATScore")
            let scoreDbns = scores.map { $0.dbn }.compactMap { $0 }
            matchingScoresRequest.predicate = NSPredicate(format: "dbn in %@", argumentArray: [scoreDbns])
            let scoreBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: matchingScoresRequest)
            scoreBatchDeleteRequest.resultType = .resultTypeObjectIDs
            
            do {
                let batchDeleteResult = try context.execute(batchDeleteRequest) as? NSBatchDeleteResult
                if let deletedObjectsIDs = batchDeleteResult?.result as? [NSManagedObjectID] {
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey : deletedObjectsIDs], into: [self.persistentContainer.viewContext])
                }
                
                let scoreBatchDeleteResult = try context.execute(scoreBatchDeleteRequest) as? NSBatchDeleteResult
                if let scoreDeletedObjectsIDs = scoreBatchDeleteResult?.result as? [NSManagedObjectID] {
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey : scoreDeletedObjectsIDs], into: [self.persistentContainer.viewContext])
                }
                
                // Create new Records
                
                for school in schools {
                    _ = School(context: context, school: school)
                }

                for score in scores {
                    _ = SATScore(context: context, score: score)
                }
                
                createDownloadHistoryLog(for: schools, scores: scores)
                
                if context.hasChanges {
                    do {
                        try context.save()
                    } catch {
                        print("Error: \(error)\n Could not save Core Data context. ")
                    }
                    context.reset()
                    isSuccesful = true

                    //Notify App Data has downloaded
                    NotificationCenter.default.post(Notification.init(name: .didCompleteDownloadingData))
                }
            } catch {
                print("Error: \(error)\n Could not batch delete existing records. ")
            }
        }
        
        return isSuccesful
    }
    
    private func createDownloadHistoryLog(for school: [SchoolCodbl], scores: [SATScoreCodbl]) {
        let context = CoreDataStack().persistentContainer.viewContext
        let logEntity = NSEntityDescription.entity(forEntityName: "DownloadLog", in: context)
        let log = NSManagedObject(entity: logEntity!, insertInto: context)
    
        let date = Date()
        log.setValue(date, forKey: "date")
    
        do {
            let jsonEncoder = JSONEncoder()
            
            let schoolsData = try school.map { return try jsonEncoder.encode($0) }
            let schoolsJsonArray = schoolsData.map { return String(data: $0, encoding: .utf8)}
            let scoresData = try scores.map { return try jsonEncoder.encode($0) }
            let scoresJsonArray = scoresData.map { return String(data: $0, encoding: .utf8)}
            let data = "schools : \(schoolsJsonArray), scores : \(scoresJsonArray)"
            log.setValue(data, forKey: "data")
            log.setValue(200, forKey: "statusCode")
            log.setValue("OK", forKey: "reason")
            
            try context.save()
        } catch {
            print("Error: \(error) could not save download history log")
        }
    }
}
