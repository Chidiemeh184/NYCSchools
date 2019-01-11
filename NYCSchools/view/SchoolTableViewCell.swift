//
//  SchoolTableViewCell.swift
//  NYCSchools
//
//  Created by Chidi Emeh on 1/9/19.
//  Copyright © 2019 Chidi Emeh. All rights reserved.
//

import UIKit

class SchoolTableViewCell: UITableViewCell {
    
    //Outlets
    @IBOutlet weak var schoolNameLabel: UILabel!
    @IBOutlet weak var testScoreLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var gradesLabel: UILabel!
    
    //Properties
    static let reuseIdentifier = "SchoolTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpWith(school: School) {
        schoolNameLabel.text = school.schoolName ?? ""
        testScoreLabel.text = school.requirement2of1
        stateLabel.text = "\(school.city ?? ""), \(school.stateCode ?? "")"
        gradesLabel.text = " "
    }
    
}
