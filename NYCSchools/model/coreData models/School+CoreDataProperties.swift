//
//  School+CoreDataProperties.swift
//  NYCSchools
//
//  Created by Chidi Emeh on 1/8/19.
//  Copyright © 2019 Chidi Emeh. All rights reserved.
//
//

import Foundation
import CoreData

extension School {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<School> {
        return NSFetchRequest<School>(entityName: "School")
    }

    @NSManaged public var academicopportunities1: String?
    @NSManaged public var academicopportunities2: String?
    @NSManaged public var admissionspriority11: String?
    @NSManaged public var admissionspriority21: String?
    @NSManaged public var admissionspriority31: String?
    @NSManaged public var attendanceRate: String?
    @NSManaged public var bbl: String?
    @NSManaged public var bin: String?
    @NSManaged public var boro: String?
    @NSManaged public var borough: String?
    @NSManaged public var buildingCode: String?
    @NSManaged public var bus: String?
    @NSManaged public var censusTract: String?
    @NSManaged public var city: String?
    @NSManaged public var code1: String?
    @NSManaged public var communityBoard: String?
    @NSManaged public var councilDistrict: String?
    @NSManaged public var dbn: String?
    @NSManaged public var directions1: String?
    @NSManaged public var ellPrograms: String?
    @NSManaged public var extracurricularActivities: String?
    @NSManaged public var faxNumber: String?
    @NSManaged public var finalgrades: String?
    @NSManaged public var grade9geapplicants1: String?
    @NSManaged public var grade9geapplicantsperseat1: String?
    @NSManaged public var grade9gefilledflag1: String?
    @NSManaged public var grade9swdapplicants1: String?
    @NSManaged public var grade9swdapplicantsperseat1: String?
    @NSManaged public var grade9swdfilledflag1: String?
    @NSManaged public var grades2018: String?
    @NSManaged public var interest1: String?
    @NSManaged public var latitude: String?
    @NSManaged public var location: String?
    @NSManaged public var longitude: String?
    @NSManaged public var method1: String?
    @NSManaged public var neighborhood: String?
    @NSManaged public var nta: String?
    @NSManaged public var offerRate1: String?
    @NSManaged public var overviewParagraph: String?
    @NSManaged public var pctStuEnoughVariety: String?
    @NSManaged public var pctStuSafe: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var primaryAddressLine1: String?
    @NSManaged public var program1: String?
    @NSManaged public var requirement1of1: String?
    @NSManaged public var requirement2of1: String?
    @NSManaged public var requirement3of1: String?
    @NSManaged public var requirement4of1: String?
    @NSManaged public var requirement5of1: String?
    @NSManaged public var school10thSeats: String?
    @NSManaged public var schoolAccessibilityDescription: String?
    @NSManaged public var schoolEmail: String?
    @NSManaged public var schoolName: String?
    @NSManaged public var schoolSports: String?
    @NSManaged public var seats101: String?
    @NSManaged public var seats9ge1: String?
    @NSManaged public var seats9swd1: String?
    @NSManaged public var stateCode: String?
    @NSManaged public var subway: String?
    @NSManaged public var totalStudents: String?
    @NSManaged public var zip: String?

}
