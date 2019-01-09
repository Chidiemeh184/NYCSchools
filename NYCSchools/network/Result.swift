//
//  Result.swift
//  NYCSchools
//
//  Created by Chidi Emeh on 1/8/19.
//  Copyright © 2019 Chidi Emeh. All rights reserved.
//
/// From https://github.com/apple/swift-evolution/blob/master/proposals/0235-add-result.md

import Foundation

public enum Result<Value> {
    case sucess(Value)
    case failure(NetworkError)
}

public enum NetworkError: Error {
    case serverNotFound
    case badURL
    case couldNotDecodeCodable
    case couldNotSaveChangesToMOC
}
