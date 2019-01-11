//
//  MapTableViewCell.swift
//  NYCSchools
//
//  Created by Chidi Emeh on 1/9/19.
//  Copyright © 2019 Chidi Emeh. All rights reserved.
//

import UIKit
import  MapKit

class MapTableViewCell: UITableViewCell {
    
    //Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var schoolAddress: UILabel!
    
    static let reuseIdentifier = "MapTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
