//
//  DownloadHistoryTableViewController.swift
//  NYCSchools
//
//  Created by Chidi Emeh on 1/9/19.
//  Copyright © 2019 Chidi Emeh. All rights reserved.
//

import UIKit
import CoreData

class DownloadHistoryTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    // MARK: Properties
    var fetchedResultController: NSFetchedResultsController<DownloadLog> = {
        return DownloadLog.getDownloadLogs(managedObjectContext: CoreDataStack().persistentContainer.viewContext)
    }()
    lazy var coreData = CoreDataStack()
    var context: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = self.coreData.persistentContainer.viewContext
        fetchedResultController.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    private func loadData() {
        fetchedResultController = DownloadLog.getDownloadLogs(managedObjectContext: context)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
         return fetchedResultController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        if let sections = fetchedResultController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let log = fetchedResultController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "downloadHistoryCell", for: indexPath)
        cell.textLabel?.text = log.date?.toString()
        cell.detailTextLabel?.text = log.statusCode.description
        return cell
    }

}
