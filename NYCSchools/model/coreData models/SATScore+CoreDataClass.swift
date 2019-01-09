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
        self.init(context: moc)
        
        dbn = score.dbn
        numOfSatTestTakers = score.numOfSatTestTakers
        satCriticalReadingAvgScore = score.satCriticalReadingAvgScore
        satMathAvgScore = score.satMathAvgScore
        satWritingAvgScore = score.satWritingAvgScore
        schoolName = score.schoolName
    }
}
