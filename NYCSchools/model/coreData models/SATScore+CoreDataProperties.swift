//
//  SATScore+CoreDataProperties.swift
//  NYCSchools
//
//  Created by Chidi Emeh on 1/8/19.
//  Copyright © 2019 Chidi Emeh. All rights reserved.
//
//

import Foundation
import CoreData

extension SATScore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SATScore> {
        return NSFetchRequest<SATScore>(entityName: "SATScore")
    }

    @NSManaged public var dbn: String?
    @NSManaged public var numOfSatTestTakers: String?
    @NSManaged public var satCriticalReadingAvgScore: String?
    @NSManaged public var satMathAvgScore: String?
    @NSManaged public var satWritingAvgScore: String?
    @NSManaged public var schoolName: String?

}
