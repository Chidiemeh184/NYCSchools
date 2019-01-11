//
//  DescriptionTableViewCell.swift
//  NYCSchools
//
//  Created by Chidi Emeh on 1/9/19.
//  Copyright © 2019 Chidi Emeh. All rights reserved.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {
    
    //Outlet
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    //Properties
    static let reuseIdentifier = "DescriptionTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
