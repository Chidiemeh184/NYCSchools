//
//  SchoolDetailTableViewController.swift
//  NYCSchools
//
//  Created by Chidi Emeh on 1/9/19.
//  Copyright © 2019 Chidi Emeh. All rights reserved.
//

import UIKit
import  CoreData

class SchoolDetailTableViewController: UITableViewController {

    // MARK: - Properties
    var score: [SATScore]?
    var school: School? {
        didSet {
            if let schooldbn = school!.dbn {
                getScores(for: schooldbn)
            }
        }
    }
    var managedObjectContext: NSManagedObjectContext!
    var isDescriptionMoreButtonTapped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibs()
        self.navigationController?.navigationItem.title = school?.schoolName ?? ""
    }
    
    func getScores(for school: String) {
        score = SATScore.getScore(for: school, managedObjectContext: managedObjectContext)
    }
    
    // MARK: - Row Height
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return CGFloat(534)
        case 1: return CGFloat(268)
        case 2: return isDescriptionMoreButtonTapped ? UITableView.automaticDimension : CGFloat(176)
        default:
            return CGFloat(0)
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.reuseIdentifier, for: indexPath) as! HeaderTableViewCell
            cell.setUpWith(school: school, score: score?.first)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: MapTableViewCell.reuseIdentifier, for: indexPath) as! MapTableViewCell
            cell.setUpWith(school: school!)
            cell.openMapToGPSButton.addTarget(self, action: #selector(SchoolDetailTableViewController.addressOpenMapTapped(sender:)), for: .touchUpInside)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionTableViewCell.reuseIdentifier, for: indexPath) as! DescriptionTableViewCell
            let moreExpandingButton = cell.moreButton
            moreExpandingButton?.addTarget(self, action: #selector(SchoolDetailTableViewController.expandDescriptionButtonTapped(sender:)), for: .touchUpInside)
            return cell
        default:
            return EmptyTableViewCell()
        }
    }
    
    @objc func expandDescriptionButtonTapped(sender: UIButton){
       isDescriptionMoreButtonTapped = !isDescriptionMoreButtonTapped ? true : false
    }
    
    // MARK: - Register Nibs
    
    private func registerNibs() {
        tableView.register(UINib(nibName: SchoolTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: SchoolTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: EmptyTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: EmptyTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: HeaderTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: HeaderTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: MapTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: MapTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: DescriptionTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: DescriptionTableViewCell.reuseIdentifier)
    }
    
    // MARK: GPS Selection
    
    @objc func addressOpenMapTapped(sender: UIButton) {
        let installedNavigationApps = ["Apple Maps" : "http://maps.apple.com" , "Google Maps" : "comgooglemaps://", "Waze" : "waze://"]
        let alert = UIAlertController(title: "Selection", message: "Select Navigation App", preferredStyle: .actionSheet)
        for (mapName, mapAddress) in installedNavigationApps {
            
            let schlat = self.school!.latitude ?? "0.0"
            let schlon = self.school!.longitude ?? "0.0"
            
            guard
                let latitude = Double(schlat), let longitude = Double(schlon) else { return }
            
            let button = UIAlertAction(title: mapName, style: .default) {  (action) in
                let schoolURL = URL(string: "\(mapAddress)?saddr=&daddr=\(latitude),\(longitude))&directionsmode=driving")
                if UIApplication.shared.canOpenURL(schoolURL!) {
                    UIApplication.shared.open(schoolURL!, options: [:], completionHandler: nil)
                }
            }
            alert.addAction(button)
        }
        self.present(alert, animated: true, completion: nil)
    }
    

}
