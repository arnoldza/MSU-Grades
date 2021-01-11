//
//  ClassInfo.swift
//  MSU Grades
//
//  Created by Zach Arnold on 12/27/20.
//

import Foundation

struct ClassInfo {
    
    var term : String
    var subjectCode : String
    var courseCode : String
    var courseTitle : String
    var instructors : [String]?     // instructors is optional
    var gradeInfo : [String : Int]
    
}

// Combine grade info of two classes
func combineGradeInfo(first: ClassInfo, second: ClassInfo) -> [String : Int] {
    var newGradeInfo = [String : Int]()
    for key in first.gradeInfo.keys {
        newGradeInfo[key] = first.gradeInfo[key]! + second.gradeInfo[key]!
    }
    return newGradeInfo
}

