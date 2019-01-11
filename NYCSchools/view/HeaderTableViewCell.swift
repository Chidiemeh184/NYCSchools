//
//  HeaderTableViewCell.swift
//  NYCSchools
//
//  Created by Chidi Emeh on 1/9/19.
//  Copyright © 2019 Chidi Emeh. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {
    
    //Outlets
    @IBOutlet weak var schoolNameLabel: UILabel!
    @IBOutlet weak var attendanceRateLabel: UILabel!
    @IBOutlet weak var criticalReadingLabel: UILabel!
    @IBOutlet weak var mathLabel: UILabel!
    @IBOutlet weak var writingLabel: UILabel!
    @IBOutlet weak var courseGradesLabel: UILabel!
    @IBOutlet weak var standardizedTestLabel: UILabel!
    @IBOutlet weak var sportsLabel: UILabel!
    @IBOutlet weak var gradesLabel: UILabel!
    @IBOutlet weak var studentsPopulationLabel: UILabel!
    
    
    //Properties
    static let reuseIdentifier = "HeaderTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpWith(school: School?, score: SATScore?) {
        schoolNameLabel.text = school?.schoolName ?? ""
        gradesLabel.text = school?.grades2018 ?? "n/a"
        studentsPopulationLabel.text = school?.totalStudents ?? "n/a"
        attendanceRateLabel.text = school?.attendanceRate?.toPercentage()
        criticalReadingLabel.text = score?.satCriticalReadingAvgScore ?? "n/a"
        mathLabel.text = score?.satMathAvgScore ?? "n/a"
        writingLabel.text = score?.satWritingAvgScore ?? "n/a"
        courseGradesLabel.text = school?.requirement1of1 ?? "n/a"
        standardizedTestLabel.text = school?.requirement2of1 ?? "n/a"
        sportsLabel.text = school?.schoolSports ?? "n/a"
    }
    
}
