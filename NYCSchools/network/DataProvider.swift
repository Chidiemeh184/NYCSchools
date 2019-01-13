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
                
                if context.hasChanges {
                    do {
                        try context.save()
                    } catch {
                        print("Error: \(error)\n Could not save Core Data context. ")
                    }
                    context.reset()
                    isSuccesful = true
                }
                
                
            } catch {
                print("Error: \(error)\n Could not batch delete existing records. ")
            }
            
        }
        
        return isSuccesful
    }
    
}
