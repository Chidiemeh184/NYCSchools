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
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Properties

    lazy var coreData = CoreDataStack()
    var dataProvider: DataProvider!
    var selectedSchool: School?
    var headerTitles: [String]?
    var searchString: String?
    var filtersViewController: FiltersViewController?
    
    var context: NSManagedObjectContext!
    
    var fetchedResultController: NSFetchedResultsController<School> = {
        return School.getSchools(managedObjectContext: CoreDataStack().persistentContainer.viewContext)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(newSchoolDataFinishedDownloading), name: .didCompleteDownloadingData, object: nil)
        context = self.coreData.persistentContainer.viewContext
        fetchedResultController.delegate = self
    }
    
    
    // MARK: Private functions
    
    private func loadData() {
        fetchedResultController = School.getSchools(managedObjectContext: context)
    }
    
    @objc private func newSchoolDataFinishedDownloading() {
        print("Download completed 🔶🔶🔶 ❇️ 🔶🔶🔶 ")
        loadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultController.sections?.count ?? 0
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
        } else if segue.identifier == "toFiltersModal" {
            let filtersNav = segue.destination as! UINavigationController
            let filtersVC = filtersNav.viewControllers.first as! FiltersViewController
            filtersVC.filterDelegate = self
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
    
    fileprivate func setUpTableView() {
        tableView.register(UINib(nibName: SchoolTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: SchoolTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: EmptyTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: EmptyTableViewCell.reuseIdentifier)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 290
    }
    
}

extension SchoolTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Text is: \(searchText)")
        if searchText.count > 3 {
            fetchedResultController = School.searchForSchool(with: searchText, context: context)
            searchBar.showsCancelButton = true
        } else {
            loadData()
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        loadData()
        tableView.reloadData()
    }
}

extension SchoolTableViewController: FiltersViewControllerDelegate {
    func filterDidFinishFilteringSchools(with frc: NSFetchedResultsController<School>) {
        fetchedResultController = frc
        tableView.reloadData()
    }
}
