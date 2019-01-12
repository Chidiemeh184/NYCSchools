//
//  School+CoreDataClass.swift
//  NYCSchools
//
//  Created by Chidi Emeh on 1/8/19.
//  Copyright © 2019 Chidi Emeh. All rights reserved.
//
//

import Foundation
import CoreData

@objc(School)
public class School: NSManagedObject {
    
    internal convenience init(context moc: NSManagedObjectContext, school: SchoolCodbl) {
        self.init(context: moc)
        
        academicopportunities1 = school.academicopportunities1
        academicopportunities2 = school.academicopportunities2
        admissionspriority11 = school.admissionspriority11
        admissionspriority21 = school.admissionspriority21
        admissionspriority31 = school.admissionspriority31
        attendanceRate = school.attendanceRate
        bbl = school.bbl
        bin = school.bin
        boro = school.boro
        borough = school.borough
        buildingCode = school.buildingCode
        bus = school.bus
        censusTract = school.censusTract
        city = school.city
        code1 = school.code1
        communityBoard = school.communityBoard
        councilDistrict = school.councilDistrict
        dbn = school.dbn
        directions1 = school.directions1
        ellPrograms = school.ellPrograms
        extracurricularActivities = school.extracurricularActivities
        faxNumber = school.faxNumber
        finalgrades = school.finalgrades
        grade9geapplicants1 = school.grade9geapplicants1
        grade9geapplicantsperseat1 = school.grade9geapplicantsperseat1
        grade9gefilledflag1 = school.grade9gefilledflag1
        grade9swdapplicants1 = school.grade9swdapplicants1
        grade9swdapplicantsperseat1 = school.grade9swdapplicantsperseat1
        grade9swdfilledflag1 = school.grade9swdfilledflag1
        grades2018 = school.grades2018
        interest1 = school.interest1
        latitude = school.latitude
        location = school.location
        longitude = school.longitude
        method1 = school.method1
        neighborhood = school.neighborhood
        nta = school.nta
        offerRate1 = school.offerRate1
        overviewParagraph = school.overviewParagraph
        pctStuEnoughVariety = school.pctStuEnoughVariety
        pctStuSafe = school.pctStuSafe
        phoneNumber = school.phoneNumber
        primaryAddressLine1 = school.primaryAddressLine1
        program1 = school.program1
        requirement1of1 = school.requirement1of1
        requirement2of1 = school.requirement2of1
        requirement3of1 = school.requirement3of1
        requirement4of1 = school.requirement4of1
        requirement5of1 = school.requirement5of1
        school10thSeats = school.school10thSeats
        schoolAccessibilityDescription = school.schoolAccessibilityDescription
        schoolEmail = school.schoolEmail
        schoolName = school.schoolName
        schoolSports = school.schoolSports
        seats101 = school.seats101
        seats9ge1 = school.seats9ge1
        seats9swd1 = school.seats9swd1
        stateCode = school.stateCode
        subway = school.subway
        totalStudents = school.totalStudents
        zip = school.zip
    }
    
    internal static func getSchools(managedObjectContext: NSManagedObjectContext) -> NSFetchedResultsController<School> {
        let fetchedResultController: NSFetchedResultsController<School>
        
        let request: NSFetchRequest<School> = School.fetchRequest()
        request.fetchBatchSize = 25

        let formatSort = NSSortDescriptor(key: "schoolName.first", ascending: true)
        let nameSort = NSSortDescriptor(key: "totalStudents", ascending: true)
        request.sortDescriptors = [formatSort, nameSort]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: "schoolName", cacheName: "NYCSchoolsLibrary")
        
        do {
            try fetchedResultController.performFetch()
        }
        catch {
            fatalError("Error in fetching records")
        }
        
        return fetchedResultController
    }
    
    internal static func searchForSchool(with schoolName: String, context: NSManagedObjectContext) -> NSFetchedResultsController<School> {
        let filteredSchoolFetchedResultController: NSFetchedResultsController<School>
        
        let request: NSFetchRequest<School> = School.fetchRequest()
        request.fetchBatchSize = 25
        request.predicate = NSPredicate(format:"schoolName contains[cd] %@", schoolName)
        let formatSort = NSSortDescriptor(key: "schoolName.first", ascending: true)
        let nameSort = NSSortDescriptor(key: "totalStudents", ascending: true)
        request.sortDescriptors = [formatSort, nameSort]
        
        filteredSchoolFetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "schoolName", cacheName: nil)
        
        do {
            try filteredSchoolFetchedResultController.performFetch()
        }
        catch {
            fatalError("Error in fetching filtered records")
        }
        
        return filteredSchoolFetchedResultController
    }

}
