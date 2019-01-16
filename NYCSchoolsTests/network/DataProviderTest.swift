//
//  DataProviderTest.swift
//  NYCSchoolsTests
//
//  Created by Chidi Emeh on 1/15/19.
//  Copyright © 2019 Chidi Emeh. All rights reserved.
//

import XCTest
import CoreData
@testable import NYCSchools

class DataProviderTest: XCTestCase {
    
    var persistentContainer: NSPersistentContainer!
    var service: NetworkService!

    override func setUp() {
        persistentContainer = CoreDataStack.shared.persistentContainer
        service = NetworkService.shared
    }
    
    func testFetchData() {
        let dataProvider = DataProvider(persistentContainer: persistentContainer, repository: service)
        dataProvider.fetchData { (error) in
            XCTAssertNotNil(error)
        }
    }
}
