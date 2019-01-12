//
//  FiltersViewController.swift
//  NYCSchools
//
//  Created by Chidi Emeh on 1/9/19.
//  Copyright © 2019 Chidi Emeh. All rights reserved.
//

import UIKit
import CoreData

class FiltersViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var criticalReadingTextfield: UITextField!
    @IBOutlet weak var mathTextField: UITextField!
    @IBOutlet weak var writingTextField: UITextField!
    @IBOutlet weak var attendanceRateSlider: UISlider!
    @IBOutlet weak var attendanceRateTextField: UITextField!
    @IBOutlet weak var studentSizeSlider: UISlider!
    @IBOutlet weak var studentSizeTextField: UITextField!
    
    // MARK: Properties
    var schoolfetchedResultController: NSFetchedResultsController<School>!
    let satScoreFetchRequest: NSFetchRequest<SATScore> = SATScore.fetchRequest()
    lazy var coreData = CoreDataStack()
    var managedObjectContext : NSManagedObjectContext!
    
    var criticalReadingScore = "400"
    var mathScore = "700"
    var writingScore = "400"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managedObjectContext = coreData.persistentContainer.viewContext
    }
    
    @IBAction func attendanceRateChanged(_ sender: UISlider) {
        
    }
    
    @IBAction func studentSizeChanged(_ sender: UISlider) {
        
    }
    
    @IBAction func applyButtonTapped(_ sender: Any) {
        //SAT Scores predicate
        let criticalReadingPredicate = NSPredicate(format: "satCriticalReadingAvgScore <= '\(criticalReadingScore)'")
        let mathPredicate = NSPredicate(format: "satMathAvgScore <= '\(mathScore)'")
        let writingPredicate = NSPredicate(format: "satWritingAvgScore = '\(writingScore)'")
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
            let attendanceSort = NSSortDescriptor(key: "attendanceRate", ascending: false)
            let totalStudentSort = NSSortDescriptor(key: "totalStudents", ascending: false)
        
            var allTheSchoolsCompoundPredicate = [NSPredicate]()
            let schoolFetchRequest: NSFetchRequest<School> = School.fetchRequest()
            for score in scores! {
                print("Score school: \(score.schoolName)")
                allTheSchoolsCompoundPredicate.append(NSPredicate(format: "dbn = %@", score.dbn!))
            }
            //schoolFetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: allTheSchoolsCompoundPredicate)
            schoolFetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: allTheSchoolsCompoundPredicate)
            schoolFetchRequest.sortDescriptors = [attendanceSort, totalStudentSort]
            
            fetchedResultController = NSFetchedResultsController(fetchRequest: schoolFetchRequest, managedObjectContext: self.coreData.persistentContainer.viewContext, sectionNameKeyPath: "schoolName", cacheName: nil)
            
            do {
                try fetchedResultController.performFetch()
                //print("Sorted Result: \(fetchedResultController.fetchedObjects?.count)")
                let schools = fetchedResultController.fetchedObjects
                for school in schools! {
                    print("Fetched: \(school.schoolName)")
                }
                print(schools?.count)
            }
            catch {
                fatalError("Error in fetching sorted School Records records")
            }
        }
        
        do {
            try managedObjectContext.execute(asyncRequest)
            //let scores = try managedObjectContext.fetch(satScoreFetchRequest)
            //print(scores.count)
        }
        catch {
            fatalError("Error in getting list of homes")
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        //Save changes
        dismiss(animated: true, completion: nil)
    }
    

}
