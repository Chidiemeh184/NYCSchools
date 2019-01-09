//
//  School+Codable.swift
//  NYCSchools
//
//  Created by Chidi Emeh on 1/7/19.
//  Copyright © 2019 Chidi Emeh. All rights reserved.
//

import Foundation

struct SchoolCodbl: Codable {
    let academicopportunities1 : String?
    let academicopportunities2 : String?
    let admissionspriority11 : String?
    let admissionspriority21 : String?
    let admissionspriority31 : String?
    let attendanceRate : String?
    let bbl : String?
    let bin : String?
    let boro : String?
    let borough : String?
    let buildingCode : String?
    let bus : String?
    let censusTract : String?
    let city : String?
    let code1 : String?
    let communityBoard : String?
    let councilDistrict : String?
    let dbn : String?
    let directions1 : String?
    let ellPrograms : String?
    let extracurricularActivities : String?
    let faxNumber : String?
    let finalgrades : String?
    let grade9geapplicants1 : String?
    let grade9geapplicantsperseat1 : String?
    let grade9gefilledflag1 : String?
    let grade9swdapplicants1 : String?
    let grade9swdapplicantsperseat1 : String?
    let grade9swdfilledflag1 : String?
    let grades2018 : String?
    let interest1 : String?
    let latitude : String?
    let location : String?
    let longitude : String?
    let method1 : String?
    let neighborhood : String?
    let nta : String?
    let offerRate1 : String?
    let overviewParagraph : String?
    let pctStuEnoughVariety : String?
    let pctStuSafe : String?
    let phoneNumber : String?
    let primaryAddressLine1: String?
    let program1 : String?
    let requirement1of1 : String?
    let requirement2of1 : String?
    let requirement3of1 : String?
    let requirement4of1 : String?
    let requirement5of1 : String?
    let school10thSeats : String?
    let schoolAccessibilityDescription : String?
    let schoolEmail : String?
    let schoolName : String?
    let schoolSports : String?
    let seats101 : String?
    let seats9ge1 : String?
    let seats9swd1 : String?
    let stateCode : String?
    let subway : String?
    let totalStudents : String?
    let zip : String?
    
    enum CodingKeys : String, CodingKey {
        case academicopportunities1
        case academicopportunities2
        case admissionspriority11
        case admissionspriority21
        case admissionspriority31
        case attendanceRate = "attendance_rate"
        case bbl
        case bin
        case boro
        case borough
        case buildingCode = "building_code"
        case bus
        case censusTract = "census_tract"
        case city
        case code1
        case communityBoard = "community_board"
        case councilDistrict = "council_district"
        case dbn
        case directions1
        case ellPrograms = "ell_programs"
        case extracurricularActivities = "extracurricular_activities"
        case faxNumber = "fax_number"
        case finalgrades
        case grade9geapplicants1
        case grade9geapplicantsperseat1
        case grade9gefilledflag1
        case grade9swdapplicants1
        case grade9swdapplicantsperseat1
        case grade9swdfilledflag1
        case grades2018
        case interest1
        case latitude
        case location
        case longitude
        case method1
        case neighborhood
        case nta
        case offerRate1 = "offer_rate1"
        case overviewParagraph = "overview_paragraph"
        case pctStuEnoughVariety = "pct_stu_enough_variety"
        case pctStuSafe = "pct_stu_safe"
        case phoneNumber = "phone_number"
        case primaryAddressLine1 = "primary_address_line_1"
        case program1
        case requirement1of1 = "requirement1_1"
        case requirement2of1 = "requirement2_1"
        case requirement3of1 = "requirement3_1"
        case requirement4of1  = "requirement4_1"
        case requirement5of1 = "requirement5_1"
        case school10thSeats = "school_10th_seats"
        case schoolAccessibilityDescription = "school_accessibility_description "
        case schoolEmail = "school_email"
        case schoolName = "school_name"
        case schoolSports = "school_sports"
        case seats101
        case seats9ge1
        case seats9swd1
        case stateCode = "state_code"
        case subway
        case totalStudents = "total_students"
        case zip
    }
}
