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

extension String {
    func toPercentage() -> String {
        var num = Double(self) ?? 0
        num = num * 100
        let formatted = String(format:"%.0f", num)
        return "\(formatted)%"
    }
}
