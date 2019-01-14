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

    let session = URLSession.shared
    
    private init() {}
    static let shared = NetworkService()
    
    func loadSchoolsData(from urlString: String, completionHandler: @escaping (Result<[SchoolCodbl]>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.badURL))
            return
        }
        
        let task = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            let httpResponse = response as! HTTPURLResponse
            
            if httpResponse.statusCode == 200 {
                if let responseData = data {
                    do{
                        let schools = try JSONDecoder().decode([SchoolCodbl].self, from: responseData)
                        completionHandler(.sucess(schools))
                        
                    } catch {
                        print("Error decoding: \(NetworkError.couldNotDecodeCodable.localizedDescription)")
                        completionHandler(.failure(NetworkError.couldNotDecodeCodable))
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
        
        let task = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            let httpResponse = response as! HTTPURLResponse
            if httpResponse.statusCode == 200 {
                if let responseData = data {
                    do {
                        let scores = try JSONDecoder().decode([SATScoreCodbl].self, from: responseData)
                        completionHandler(.sucess(scores))
                    } catch {
                        print("Error decoding: \(NetworkError.couldNotDecodeCodable.localizedDescription)")
                        completionHandler(.failure(NetworkError.couldNotDecodeCodable))
                    }
                }
            } else {
                completionHandler(.failure(.serverNotFound))
            }
        }
        task.resume()
        
    }
}
