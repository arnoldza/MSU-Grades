//
//  DatabaseHandler.swift
//  MSU Grades
//
//  Created by Zach Arnold on 12/27/20.
//

import Foundation
import SQLite3

// Map of term code prefix in database to english
let termCodeMap = ["SS": "Spring", "US": "Summer", "FS": "Fall"]

// Ordering of elements in database columns
let gradeOrder = ["4.0", "3.5", "3.0", "2.5", "2.0", "1.5", "1.0", "0.0",
                    "incomplete", "withdrawn", "pass", "no_grade", "deferred",
                    "unfinished_work", "visitor",
                    "A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D+",
                    "D", "D-", "F",
                    "auditor", "extension",
                    "conditional_pass", "no_grade_reported", "blank"]

// Opens database
func openDatabase() -> OpaquePointer? {

    var db: OpaquePointer?

    let filePath = Bundle.main.path(forResource: "courses", ofType: "sqlite")
    if sqlite3_open_v2(filePath, &db, SQLITE_OPEN_READWRITE, nil) == SQLITE_OK {
        print("Successfully opened connection to database")
        return db
    } else {
        print("Unable to open database.")
        return nil
    }
}


// query function assumes SELECT * (all columns)
// returns nil on error
func query(queryString: String) -> [ClassInfo]? {
    
    let db = openDatabase()
    var allInfo = [ClassInfo]()
    var queryStatement: OpaquePointer?
    
    // Prepare query
    if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) ==
        SQLITE_OK {
    
    
        // while results are still being returned by db query
        while sqlite3_step(queryStatement) == SQLITE_ROW {
            
            // Collect info from database columns
            guard let queryResultCol0 = sqlite3_column_text(queryStatement, 0) else {
                print("Query col 0 is nil")
                return nil
            }
            guard let queryResultCol2 = sqlite3_column_text(queryStatement, 2) else {
                print("Query col 2 is nil")
                return nil
            }
            guard let queryResultCol3 = sqlite3_column_text(queryStatement, 3) else {
                print("Query col 3 is nil")
                return nil
            }
            guard let queryResultCol4 = sqlite3_column_text(queryStatement, 4) else {
                print("Query col 4 is nil")
                return nil
            }
            guard let queryResultCol5 = sqlite3_column_text(queryStatement, 5) else {
                print("Query col 5 is nil")
                return nil
            }
            
            // Get term code
            let termCodeRaw = String(cString: queryResultCol0)
            let termCode = termCodeMap[String(termCodeRaw.prefix(2))]! + " 20" + String(termCodeRaw.suffix(2))

            // subject & course codes, title
            let subjectCode = String(cString: queryResultCol2)
            let courseCode = String(cString: queryResultCol3)
            let courseTitle = String(cString: queryResultCol4)
            
            // Instructors
            let instructorsRaw = String(cString: queryResultCol5)
            let instructorsRawArray = instructorsRaw.split(separator: "|")
            var instructors = [String]()
            
            // Insert each instructor into array
            for prof in instructorsRawArray {
                var instructor = prof.trimmingCharacters(in: .whitespacesAndNewlines)
                // Convert to standard non-comma formatting if needed
                if instructor.contains(",") {
                    let components = instructor.components(separatedBy: ",")
                    instructor = components[1] + " " + components[0]
                }
                // Capitalize instructor name
                instructors.append(instructor.capitalized)
            }
            
            // Get grade info
            var gradeData = [String : Int]()
            // iterate over each grade value
            for (i, val) in gradeOrder.enumerated() {
                guard let queryResult = sqlite3_column_text(queryStatement, Int32(i) + 10) else {
                    print("Query col \(i + 10) is nil")
                    return nil
                }
            
                gradeData[val] = Int(String(cString: queryResult))
            }

            // Append collected class info to all info
            allInfo.append(ClassInfo(term: termCode, subjectCode: subjectCode, courseCode: courseCode, courseTitle: courseTitle, instructors: instructors, gradeInfo: gradeData))
            
            // Comment out this line to see what classes were queried
            // print("\(termCode) ---- \(subjectCode) ---- \(courseCode) ---- \(instructors) ---- \(gradeData)")

        }
        
    } else {
        // if query is not preparable
        let errorMessage = String(cString: sqlite3_errmsg(db))
        print("\nQuery is not prepared -- \(errorMessage)")
    }
    
    // finalize query statement and close db
    sqlite3_finalize(queryStatement)
    sqlite3_close(db)
    return allInfo
}
