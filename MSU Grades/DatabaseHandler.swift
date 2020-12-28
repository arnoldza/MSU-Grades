//
//  DatabaseHandler.swift
//  MSU Grades
//
//  Created by Zach Arnold on 12/27/20.
//

import Foundation
import SQLite3


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


let queryStatementString = "SELECT term_code, subject_code, course_code, course_title, instructors, \"4.0\", \"3.5\", \"3.0\", \"2.5\", \"2.0\", \"1.5\", \"1.0\". \"0.0\" FROM courses WHERE subject_code == \"CSE\" AND course_code == \"231\" ORDER BY ROWID;"


func query(db: OpaquePointer, queryString: String) -> [ClassInfo] {
    
    var queryStatement: OpaquePointer?
    // 1
    if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) ==
        SQLITE_OK {
    
        // 2
        while sqlite3_step(queryStatement) == SQLITE_ROW {
            
            guard let queryResultCol1 = sqlite3_column_text(queryStatement, 4) else {
                print("Query result is nil")
                return []
            }
    
            guard let queryResultCol4 = sqlite3_column_text(queryStatement, 4) else {
                print("Query result is nil")
                return []
            }
            
            guard let queryResultCol5 = sqlite3_column_text(queryStatement, 5) else {
                print("Query result is nil")
                return []
            }
            
            let subjectCode = String(cString: queryResultCol4)
            let courseCode = String(cString: queryResultCol5)

            
            
            print("\(subjectCode) ---- \(courseCode)")

        }
        
    } else {
        // 6
        let errorMessage = String(cString: sqlite3_errmsg(db))
        print("\nQuery is not prepared -- \(errorMessage)")
    }
    // 7
    sqlite3_finalize(queryStatement)
    return []
}
