//
//  AppDelegate.swift
//  NYCSchools
//
//  Created by Chidi Emeh on 1/7/19.
//  Copyright © 2019 Chidi Emeh. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coreData = CoreDataStack()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        
//        let schoolsStoryboard = UIStoryboard(name: "Schools", bundle: nil)
//        let schoolNavController =  schoolsStoryboard.instantiateViewController(withIdentifier: "schoolNavigationController") as! UINavigationController
//        let schoolTVC = schoolNavController.viewControllers.first as! SchoolTableViewController
//        let dataProvider = DataProvider(persistentContainer: coreData.persistentContainer, repository: NetworkService.shared)
//        schoolTVC.context = coreData.persistentContainer.viewContext
//        
//        dataProvider.fetchData { (error) in
//            
//            if error == nil {
//                print("Downloaded without problems")
//            }
//            
//            DispatchQueue.main.async {
//                print("Error loading data provider")
//            }
//        }

        
//        deleteRecords()
//
//        let schools = "https://data.cityofnewyork.us/resource/97mf-9njv.json"
//        let scores = "https://data.cityofnewyork.us/resource/734v-jeq5.json"
//
//        let context = coreData.persistentContainer.viewContext
//        let networkService = NetworkService(managedObjectContext: context)
//
//        _ = networkService.loadSchoolsData(from: schools) { response in
//            switch response {
//            case .sucess(let nycschools):
//                print(nycschools[0])
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//
//        _ = networkService.loadScoresData(from: scores) { response in
//            switch response {
//            case .sucess(let satscores):
//                print(satscores[0])
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        coreData.saveContext()
    }


//    func deleteRecords() {
//        let moc = coreData.persistentContainer.viewContext
//        let schools: NSFetchRequest<School> = School.fetchRequest()
//        let scores: NSFetchRequest<SATScore> = SATScore.fetchRequest()
//
//        var deleteRequest: NSBatchDeleteRequest
//        var deleteResults: NSPersistentStoreResult
//        do {
//            deleteRequest = NSBatchDeleteRequest(fetchRequest: schools as! NSFetchRequest<NSFetchRequestResult>)
//            deleteResults = try moc.execute(deleteRequest)
//
//            deleteRequest = NSBatchDeleteRequest(fetchRequest: scores as! NSFetchRequest<NSFetchRequestResult>)
//            deleteResults = try moc.execute(deleteRequest)
//
//            try moc.save()
//        }
//        catch {
//            fatalError("Failed removing existing records")
//        }
//
//    }
    
    
}

