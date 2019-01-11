//
//  AlertMessages.swift
//  NYCSchools
//
//  Created by Chidi Emeh on 1/10/19.
//  Copyright © 2019 Chidi Emeh. All rights reserved.
//

import UIKit

struct AlertMessage {
    static func error(for message: String) -> UIAlertController {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        let alert = UIAlertController(title: "Error ☹️", message: message, preferredStyle: .alert)
        alert.addAction(okAction)
        
        return alert
    }
}
