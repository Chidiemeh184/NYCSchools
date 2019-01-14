//
//  DownloadLog+CoreDataClass.swift
//  NYCSchools
//
//  Created by Chidi Emeh on 1/13/19.
//  Copyright © 2019 Chidi Emeh. All rights reserved.
//
//

import Foundation
import CoreData

@objc(DownloadLog)
public class DownloadLog: NSManagedObject {

    
    internal static func getDownloadLogs(managedObjectContext: NSManagedObjectContext) -> NSFetchedResultsController<DownloadLog> {
        let fetchedResultController: NSFetchedResultsController<DownloadLog>
        
        let request: NSFetchRequest<DownloadLog> = DownloadLog.fetchRequest()
        let dateSort = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [dateSort]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: "date", cacheName: nil)
        
        do {
            try fetchedResultController.performFetch()
        }
        catch {
            fatalError("Error in fetching records")
        }
        
        return fetchedResultController
    }
}
