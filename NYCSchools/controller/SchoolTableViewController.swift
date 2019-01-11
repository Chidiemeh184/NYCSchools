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
    
    // MARK: - Outlets
    @IBOutlet weak var gridSelectionStyleSegmentedControl: UISegmentedControl!
    
    // MARK: - Properties
    var fetchedResultController: NSFetchedResultsController<School>!
    lazy var coreData = CoreDataStack()
    var selectedSchool: School?
    var headerTitles: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: SchoolTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: SchoolTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: EmptyTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: EmptyTableViewCell.reuseIdentifier)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 290
        
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
        let school = fetchedResultController.object(at: indexPath)
        switch gridSelectionStyleSegmentedControl.selectedSegmentIndex {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "schoolCell", for: indexPath)
            cell.textLabel?.text = school.schoolName ?? ""
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: SchoolTableViewCell.reuseIdentifier, for: indexPath) as! SchoolTableViewCell
            cell.setUpWith(school: school)
            return cell
        default:
            return EmptyTableViewCell()
        }
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return fetchedResultController.sectionIndexTitles
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return fetchedResultController.section(forSectionIndexTitle: title, at: index)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "schoolToSchoolDetail" {
            guard let indexPath = sender as? (IndexPath) else { return }
            let school = fetchedResultController.object(at: indexPath)
            let schoolDetailTVC = segue.destination as! SchoolDetailTableViewController
            schoolDetailTVC.managedObjectContext = coreData.persistentContainer.viewContext
            schoolDetailTVC.school = school
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         self.performSegue(withIdentifier: "schoolToSchoolDetail", sender: (indexPath))
    }
    
    @IBAction func gridDisplayStyleSelected(_ sender: UISegmentedControl) {
        self.tableView.beginUpdates()
        self.tableView.reloadData()
        self.tableView.endUpdates()
    }
    
}
