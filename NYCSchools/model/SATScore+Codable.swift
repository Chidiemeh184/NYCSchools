//
//  SATScore+Codable.swift
//  NYCSchools
//
//  Created by Chidi Emeh on 1/8/19.
//  Copyright © 2019 Chidi Emeh. All rights reserved.
//

import Foundation

struct SATScoreCodbl: Codable {
    let dbn : String?
    let numOfSatTestTakers : String?
    let satCriticalReadingAvgScore : String?
    let satMathAvgScore : String?
    let satWritingAvgScore : String?
    let schoolName : String?
    
    enum CodingKeys : String, CodingKey {
        case dbn
        case numOfSatTestTakers = "num_of_sat_test_takers"
        case satCriticalReadingAvgScore = "sat_critical_reading_avg_score"
        case satMathAvgScore = "sat_math_avg_score"
        case satWritingAvgScore = "sat_writing_avg_score"
        case schoolName = "school_name"
    }
}
