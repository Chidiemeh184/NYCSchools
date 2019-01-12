//
//  FiltersViewController.swift
//  NYCSchools
//
//  Created by Chidi Emeh on 1/9/19.
//  Copyright © 2019 Chidi Emeh. All rights reserved.
//

import UIKit
import CoreData

protocol FiltersViewControllerDelegate {
    func filterDidFinishFilteringSchools(with frc: NSFetchedResultsController<School>)
}

class FiltersViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var criticalReadingTextfield: UITextField!
    @IBOutlet weak var mathTextField: UITextField!
    @IBOutlet weak var writingTextField: UITextField!
    
    // MARK: Properties
    var schoolfetchedResultController: NSFetchedResultsController<School>!
    let satScoreFetchRequest: NSFetchRequest<SATScore> = SATScore.fetchRequest()
    lazy var coreData = CoreDataStack()
    var managedObjectContext : NSManagedObjectContext!

    var filterDelegate: FiltersViewControllerDelegate?
    
    var criticalReadingScore = "999"
    var mathScore = "999"
    var writingScore = "999"
    var isAttendanceRateApplied = false
    var isTotalStudentPopulationApplied = false
    var equalitySign = ">"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managedObjectContext = coreData.persistentContainer.viewContext
    }
    
    @IBAction func fromToBelowSegmentControlTapped(_ sender: UISegmentedControl) {
        equalitySign = sender.selectedSegmentIndex == 0 ? ">" : "<"
    }
    
    @IBAction func attendanceSwitchChanged(_ sender: UISwitch) {
        isAttendanceRateApplied = sender.isOn ? true : false
    }
    
    @IBAction func totalStudentSwitchChanged(_ sender: UISwitch) {
        isTotalStudentPopulationApplied = sender.isOn ? true : false
    }
    
    @IBAction func restoreButtonTapped(_ sender: UIButton) {
        let defaultFetchResultController = School.getSchools(managedObjectContext: CoreDataStack().persistentContainer.viewContext)
        self.filterDelegate?.filterDidFinishFilteringSchools(with: defaultFetchResultController)
    }
    
    @IBAction func updateButtonTapped(_ sender: UIButton) {
        //SAT Scores predicate
        let criticalReadingPredicate = NSPredicate(format: "satCriticalReadingAvgScore \(equalitySign)= '\(criticalReadingScore)'")
        let mathPredicate = NSPredicate(format: "satMathAvgScore \(equalitySign)= '\(mathScore)'")
        let writingPredicate = NSPredicate(format: "satWritingAvgScore =\(equalitySign) '\(writingScore)'")
        let predicate = NSCompoundPredicate(type: .or, subpredicates: [criticalReadingPredicate, mathPredicate, writingPredicate])
        
        satScoreFetchRequest.predicate = predicate
        
        let asyncRequest = NSAsynchronousFetchRequest(fetchRequest: satScoreFetchRequest) { (results: NSAsynchronousFetchResult<SATScore>) in
            
            let filtered = results.finalResult?.filter({ (score: SATScore) -> Bool in
                return score.satCriticalReadingAvgScore != "s" && score.satMathAvgScore != "s" && score.satWritingAvgScore != "s"
            })
            let scores = filtered
            print(scores?.count)
            print("Done Searching")
            let fetchedResultController: NSFetchedResultsController<School>
            let attendanceSort = NSSortDescriptor(key: "attendanceRate", ascending: self.isAttendanceRateApplied)
            let totalStudentSort = NSSortDescriptor(key: "totalStudents", ascending: self.isTotalStudentPopulationApplied)
            var allTheSchoolsCompoundPredicate = [NSPredicate]()
            let schoolFetchRequest: NSFetchRequest<School> = School.fetchRequest()
            
            for score in scores! {
                allTheSchoolsCompoundPredicate.append(NSPredicate(format: "dbn = %@", score.dbn!))
            }

            schoolFetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: allTheSchoolsCompoundPredicate)
            schoolFetchRequest.sortDescriptors = [attendanceSort, totalStudentSort]
            
            fetchedResultController = NSFetchedResultsController(fetchRequest: schoolFetchRequest, managedObjectContext: self.coreData.persistentContainer.viewContext, sectionNameKeyPath: "schoolName", cacheName: nil)
            
            do {
                try fetchedResultController.performFetch()
                self.filterDelegate?.filterDidFinishFilteringSchools(with: fetchedResultController)
                let schools = fetchedResultController.fetchedObjects
                print(schools?.count)
            }
            catch {
                fatalError("Error in fetching sorted School Records records")
            }
        }
        
        do {
            try managedObjectContext.execute(asyncRequest)
        }
        catch {
            fatalError("Error in getting list of homes")
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension FiltersViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let numberRegEx  = ".*[0-9]+.*"
        let numbersOnlyPredicate = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        
        if let text = textField.text , text.count > 0, (numbersOnlyPredicate.evaluate(with: text)) {
            switch textField.tag {
            case 0:
                criticalReadingScore = text
            case 1:
                writingScore = text
            case 2:
                mathScore = text
            default:
                return
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
