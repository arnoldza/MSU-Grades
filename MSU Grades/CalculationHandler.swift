//
//  CalculationHandler.swift
//  MSU Grades
//
//  Created by Zach Arnold on 1/3/21.
//

import Foundation



func getGradeData(gpaMap : [String : Int]) ->
    (average: Double, median: String, total: Int) {
    
    // Get total students
    let totalStudents = Array(gpaMap.values).reduce(0, +)
    
    // Weights for averages
    let weightsMap = ["4.0": 4.0, "3.5": 3.5, "3.0": 3.0, "2.5": 2.5,
                      "2.0": 2.0, "1.5": 1.5, "1.0": 1.0, "0.0": 0.0,
                      "A+" : 4.0, "A" : 4.0, "A-" : 3.67, "B+" : 3.33,
                      "B" : 3.0, "B-" : 2.67, "C+" : 2.33, "C" : 2.0,
                      "C-" : 1.67, "D+" : 1.33, "D" : 1.0, "D-" : 0.67,
                      "F" : 0.0]
    
    var averageNum = 0.0
    var totalGrades = 0
    
    for (key, val) in weightsMap {
        averageNum += Double(gpaMap[key]!) * val
        totalGrades += Int(gpaMap[key]!)
    }
    
    var averageGrade = -1.0
    var medianGrade = ""
    
    // If there are grades to get data on
    if totalGrades != 0 {
        // Get average
        averageGrade = averageNum / Double(totalGrades)
        
        // Get median
        let gpaScale = ["4.0", "3.5", "3.0", "2.5", "2.0", "1.5", "1.0", "0.0"]
        
        medianGrade = getMedian(gpaMap: gpaMap, values: gpaScale, totalGrades: totalGrades)
        
        // Get median grade of alpha grades
        if medianGrade == "" {
            
            let letterScale = ["A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D+", "D", "D-", "F"]
            medianGrade = getMedian(gpaMap: gpaMap, values: letterScale, totalGrades: totalGrades)
            
        }
    }
    // Bad input will return -1.0 for avg, "" for median, 0 for total
    return (average: averageGrade, median: medianGrade, total: totalStudents)
}


// Gets median grade value given total num of grades and grade scale
func getMedian(gpaMap: [String: Int], values: [String], totalGrades: Int) -> String {
    
    var totalSeen = 0
    for val in values {
        totalSeen += gpaMap[val]!
        
        if totalSeen >= Int(totalGrades / 2) {
            return val
        }
    }
    return ""
}
