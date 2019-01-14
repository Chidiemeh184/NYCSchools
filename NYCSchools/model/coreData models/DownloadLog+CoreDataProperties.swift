//
//  DownloadLog+CoreDataProperties.swift
//  NYCSchools
//
//  Created by Chidi Emeh on 1/13/19.
//  Copyright © 2019 Chidi Emeh. All rights reserved.
//
//

import Foundation
import CoreData


extension DownloadLog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DownloadLog> {
        return NSFetchRequest<DownloadLog>(entityName: "DownloadLog")
    }

    @NSManaged public var date: Date?
    @NSManaged public var statusCode: Int16
    @NSManaged public var reason: String?
    @NSManaged public var data: String?

}
