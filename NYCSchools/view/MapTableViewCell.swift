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
    @IBOutlet weak var openMapToGPSButton: UIButton!
    
    //Properties
    static let reuseIdentifier = "MapTableViewCell"
    var latitude: Double!
    var longitude: Double!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpWith(school: School) {
        let schlat = school.latitude ?? "0.0"
        let schlon = school.longitude ?? "0.0"
        
        if let latitude = Double(schlat), let longitude = Double(schlon) {
            self.longitude = longitude
            self.latitude = latitude
        }

        let schoolLocation = CLLocation(latitude: latitude, longitude: longitude)
        let regionRadius: CLLocationDistance = 1000.0
        var region = MKCoordinateRegion(center: schoolLocation.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        region.span.latitudeDelta = 0.002
        region.span.longitudeDelta = 0.002
        let annotation = MKPointAnnotation()
        annotation.coordinate = schoolLocation.coordinate
        mapView.addAnnotation(annotation)
        mapView.setRegion(region, animated: false)
        
        guard
            let addressLine1 = school.primaryAddressLine1,
            let city = school.city,
            let stateCode = school.stateCode,
            let zip = school.zip else { return }
        schoolAddress.text = "\(addressLine1), \(city), \(stateCode) \(zip)"
    }
    
}
