//
//  SATScore+CoreDataClass.swift
//  NYCSchools
//
//  Created by Chidi Emeh on 1/8/19.
//  Copyright © 2019 Chidi Emeh. All rights reserved.
//
//

import Foundation
import CoreData

@objc(SATScore)
public class SATScore: NSManagedObject {

    internal convenience init(context moc: NSManagedObjectContext, score: SATScoreCodbl) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: moc)
        self.init(entity: entity!, insertInto: moc)
        dbn = score.dbn
        numOfSatTestTakers = score.numOfSatTestTakers
        satCriticalReadingAvgScore = score.satCriticalReadingAvgScore
        satMathAvgScore = score.satMathAvgScore
        satWritingAvgScore = score.satWritingAvgScore
        schoolName = score.schoolName
    }
    
    static func getScore(for dbn: String, managedObjectContext: NSManagedObjectContext) -> [SATScore] {
        let request: NSFetchRequest<SATScore> = SATScore.fetchRequest()
        request.predicate = NSPredicate(format: "dbn == %@", dbn)
        
        do {
            let result = try managedObjectContext.fetch(request)
            return result
        }
        catch {
            fatalError()
        }
    }
}
