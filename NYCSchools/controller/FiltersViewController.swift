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
    
    var criticalReadingScore = "234"
    var mathScore = "234"
    var writingScore = "345"
    
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
        let criticalReadingPredicate = NSPredicate(format: "satCriticalReadingAvgScore < '\(criticalReadingScore)'")
        let mathPredicate = NSPredicate(format: "satMathAvgScore < '\(mathScore)'")
        let writingPredicate = NSPredicate(format: "satWritingAvgScore < '\(writingScore)'")
        let predicate = NSCompoundPredicate(type: .or, subpredicates: [criticalReadingPredicate, mathPredicate, writingPredicate])
        
        satScoreFetchRequest.predicate = predicate
        
        let asyncRequest = NSAsynchronousFetchRequest(fetchRequest: satScoreFetchRequest) { (results: NSAsynchronousFetchResult<SATScore>) in
            let scores = results.finalResult
            print(scores?.count)
            print("Done Searching")
            
            var schoolRequests: [NSFetchRequest<School>]!
            let fetchedResultController: NSFetchedResultsController<School>
            let formatSort = NSSortDescriptor(key: "schoolName.first", ascending: true)
            let nameSort = NSSortDescriptor(key: "totalStudents", ascending: true)
        
            
            for score in scores! {
                let request: NSFetchRequest<School> = School.fetchRequest()
                request.predicate = NSPredicate(format: "dbn = %@", score.dbn!)
            }
            
            //let fetchedResultController = NSFetchedResultsController(fetchRequest: NSFetchRequest<School>, managedObjectContext: managedObjectContext, sectionNameKeyPath: "schoolName", cacheName: "NYCSchoolsLibrary")
            
            do {
                //try fetchedResultController.performFetch()
            }
            catch {
                fatalError("Error in fetching records")
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
