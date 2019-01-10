//
//  SchoolTableViewController.swift
//  NYCSchools
//
//  Created by Chidi Emeh on 1/8/19.
//  Copyright © 2019 Chidi Emeh. All rights reserved.
//

import UIKit
import CoreData

class SchoolTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var fetchedResultController: NSFetchedResultsController<School>!
    lazy var coreData = CoreDataStack()
    var selectedSchool: School?
    var headerTitles: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    // MARK: Private functions
    
    private func loadData() {
        fetchedResultController = School.getSchools(managedObjectContext: self.coreData.persistentContainer.viewContext)
        fetchedResultController.delegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedResultController.sections {
            print("number of sections: \(sections.indices)")
            return sections.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        return 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "schoolCell", for: indexPath)
        
        let school = fetchedResultController.object(at: indexPath)
        cell.textLabel?.text = school.schoolName ?? ""
        
        return cell
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return fetchedResultController.sectionIndexTitles
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return fetchedResultController.section(forSectionIndexTitle: title, at: index)
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let sectionName = fetchedResultController.sectionIndexTitles
//        let name = sectionName[1]
//        return  name
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
