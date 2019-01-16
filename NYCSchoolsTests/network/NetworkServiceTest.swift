//
//  NetworkServiceTest.swift
//  NYCSchoolsTests
//
//  Created by Chidi Emeh on 1/15/19.
//  Copyright © 2019 Chidi Emeh. All rights reserved.
//

import XCTest
@testable import NYCSchools

class NetworkServiceTest: XCTestCase {
    func testInitializeSingleton() {
        let service = NetworkService.shared
        
        XCTAssertNotNil(service)
    }
    
    func testLoadSchoolDataWithBadUrl() {
        let url = "bad url"
        _ = NetworkService.shared.loadSchoolsData(from: url) { result in
            switch result {
            case .sucess(_):
                break
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.badURL)
            }
        }
    }
    
    func testLoadSchoolDataWithValidUrl() {
        let url = "https://data.cityofnewyork.us/resource/97mf-9njv.json"
        _ = NetworkService.shared.loadSchoolsData(from: url) { result in
            switch result {
            case .sucess(let schools):
                let firstSchool = schools.first
                XCTAssertNotNil(firstSchool)
            case .failure(_):
                break
            }
        }
    }
    
    func testLoadedeScoresDataWithValidUrl() {
        let url = "https://data.cityofnewyork.us/resource/734v-jeq5.json"
        _ = NetworkService.shared.loadScoresData(from: url) { result in
            switch result {
            case .sucess(let scores):
                let numOfScores = scores.count
                XCTAssertGreaterThan(numOfScores, 1)
            case .failure(_):
                break
            }
        }
    }
    

}
