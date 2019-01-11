//
//  SchoolDetailTableViewController.swift
//  NYCSchools
//
//  Created by Chidi Emeh on 1/9/19.
//  Copyright © 2019 Chidi Emeh. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

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
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 350
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
            cell.setUpWith(school: school!)
            return cell
        default:
            return EmptyTableViewCell()
        }
    }
    
    // MARK: - Compose Email
    @IBAction func composeEmail(_ sender: UIBarButtonItem) {
        if !MFMailComposeViewController.canSendMail() {
            let errorAlert = AlertMessage.error(for: "Email composing is unavailable")
            self.present(errorAlert, animated: true, completion: nil)
            return
        }
       
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
    
        composeVC.setToRecipients([school?.schoolEmail ?? " "])
        composeVC.setSubject("NYC School Inquiry")
        composeVC.setMessageBody("Request Admission information", isHTML: false)
        
        self.present(composeVC, animated: true, completion: nil)
    }
    
    // MARK: - Expand description with Animations
    
    @objc func expandDescriptionButtonTapped(sender: UIButton) {
        print("Expanded ... ")
        let changedTitle = isDescriptionMoreButtonTapped ? "more" : "less"
        sender.setTitle(changedTitle, for: .normal)
        isDescriptionMoreButtonTapped = !isDescriptionMoreButtonTapped ? true : false
        let rowIndexPath = sender.tag
        let indexPath = IndexPath(item: rowIndexPath, section: 0)
        
        UIView.animate(withDuration: 0.4) { [unowned self] in
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: [indexPath], with: .fade)
            self.tableView.endUpdates()
        }
    }
    
    // MARK: - Register Nibs
    
    private func registerNibs() {
        tableView.register(UINib(nibName: EmptyTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: EmptyTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: HeaderTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: HeaderTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: MapTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: MapTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: DescriptionTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: DescriptionTableViewCell.reuseIdentifier)
    }
    
    // MARK: - GPS Selection from Address
    
    @objc func addressOpenMapTapped(sender: UIButton) {
        let installedNavigationApps = ["Apple Maps" : "http://maps.apple.com" , "Google Maps" : "comgooglemaps://", "Waze" : "waze://"]
        let alert = UIAlertController(title: "Selection", message: "Select Navigation App", preferredStyle: .actionSheet)
        for (mapName, mapAddress) in installedNavigationApps {
            let schlat = self.school!.latitude ?? "0.0"
            let schlon = self.school!.longitude ?? "0.0"
            
            guard
                let latitude = Double(schlat), let longitude = Double(schlon) else { return }
            
            if latitude == 0.0 && longitude == 0.0 {
                let errorAlert = AlertMessage.error(for: "Could not find latitude and longitude for the school address")
                self.present(errorAlert, animated: true, completion: nil)
                return
            }
            
            let button = UIAlertAction(title: mapName, style: .default) {  (action) in
                let schoolURL = URL(string: "\(mapAddress)?saddr=&daddr=\(latitude),\(longitude))&directionsmode=driving")
                if UIApplication.shared.canOpenURL(schoolURL!) {
                    UIApplication.shared.open(schoolURL!, options: [:], completionHandler: nil)
                }
            }
            alert.addAction(button)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: Compose and send email

extension SchoolDetailTableViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let error = error {
            let errorAlert = AlertMessage.error(for: error.localizedDescription)
            self.present(errorAlert, animated: true, completion: nil)
        }
        dismiss(animated: true, completion: nil)
    }
    
}
