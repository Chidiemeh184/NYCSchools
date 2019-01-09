//
//  NetworkService.swift
//  NYCSchools
//
//  Created by Chidi Emeh on 1/8/19.
//  Copyright © 2019 Chidi Emeh. All rights reserved.
//

import Foundation
import CoreData

class NetworkService {

    internal var managedObjectContext: NSManagedObjectContext!
    let session = URLSession.shared
    
    internal init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    deinit {
        self.managedObjectContext = nil
    }
    
    func loadSchoolsData(from urlString: String, completionHandler: @escaping (Result<[SchoolCodbl]>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.badURL))
            return
        }
        
        let task = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            let httpResponse = response as! HTTPURLResponse
            
            if httpResponse.statusCode == 200 {
                self.managedObjectContext.perform {
                    if let responseData = data {
                        do{
                            let schools = try JSONDecoder().decode([SchoolCodbl].self, from: responseData)

                            for school in schools {
                                _ = School(context: self.managedObjectContext, school: school)
                            }

                            do {
                                _ = try self.managedObjectContext.save()
                                completionHandler(.sucess(schools))
                            } catch {
                                self.managedObjectContext.rollback()
                                completionHandler(.failure(NetworkError.couldNotSaveChangesToMOC))
                                print("Error decoding: \(NetworkError.couldNotSaveChangesToMOC.localizedDescription)")
                            }
                            
                        } catch {
                            print("Error decoding: \(NetworkError.couldNotDecodeCodable.localizedDescription)")
                            completionHandler(.failure(NetworkError.couldNotDecodeCodable))
                        }
                    }
                }
            } else {
                 completionHandler(.failure(.serverNotFound))
            }
        }
        task.resume()

    }
    
    func loadScoresData(from urlString: String, completionHandler: @escaping (Result<[SATScoreCodbl]>) -> Void) {
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.badURL))
            return
        }
        
        let task = session.dataTask(with: url) { [weak self] (data: Data?, response: URLResponse?, error: Error?) in
            guard let self = self else { return }
            let httpResponse = response as! HTTPURLResponse
            
            if httpResponse.statusCode == 200 {
                self.managedObjectContext.perform {
                    if let responseData = data {
                        do{
                            let scores = try JSONDecoder().decode([SATScoreCodbl].self, from: responseData)
                            for score in scores {
                                _ = SATScore(context: self.managedObjectContext, score: score)
                            }

                            do {
                              _ = try self.managedObjectContext.save()
                                completionHandler(.sucess(scores))
                            } catch {
                                self.managedObjectContext.rollback()
                                completionHandler(.failure(NetworkError.couldNotSaveChangesToMOC))
                                print("Error decoding: \(NetworkError.couldNotSaveChangesToMOC.localizedDescription)")
                            }
            
                        } catch {
                            print("Error decoding: \(NetworkError.couldNotDecodeCodable.localizedDescription)")
                            completionHandler(.failure(NetworkError.couldNotDecodeCodable))
                        }
                    }
                }
            } else {
                completionHandler(.failure(.serverNotFound))
            }
        }
        task.resume()
        
    }
}
