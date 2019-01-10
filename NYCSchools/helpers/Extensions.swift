//
//  Extensions.swift
//  NYCSchools
//
//  Created by Chidi Emeh on 1/9/19.
//  Copyright © 2019 Chidi Emeh. All rights reserved.
//

import Foundation

extension NSString {
    func firstChar() -> String {
        if self.length == 0 {
            return ""
        }
        return self.substring(to: 1)
    }
}
