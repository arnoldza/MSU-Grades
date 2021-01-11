//
//  CourseFilterHelper.swift
//  MSU Grades
//
//  Created by Zach Arnold on 1/9/21.
//

import Foundation


// Filter all class data by semester
// This function assumes that inputted array is sorted by semester
func filterBySemester(classData: [ClassInfo]) -> [ClassInfo] {
    
    // Array of filtered courses
    var filtered = [ClassInfo]()
    
    // Look at each course in full queried class data
    for course in classData {
        
        // If this semester hasnt been seen yet
        if filtered.count == 0 || filtered.last!.term != course.term {
            filtered.append(ClassInfo(term: course.term, subjectCode: course.subjectCode, courseCode: course.courseCode, courseTitle: course.courseTitle, instructors: nil, gradeInfo: course.gradeInfo))
        } else {
            let prev = filtered[filtered.count - 1]
            filtered[filtered.count - 1] = ClassInfo(term: prev.term, subjectCode: prev.subjectCode, courseCode: prev.courseCode, courseTitle: prev.courseTitle, instructors: nil, gradeInfo: combineGradeInfo(first: prev, second: course))
        }
    }
    
    // Each class in array has nil instructors
    return filtered
}



// Filter all class data by instructor
// This function assumes that inputted array is sorted by semester
func filterByInstructor(classData: [ClassInfo]) -> [ClassInfo] {
    
    // Array of filtered courses
    var filtered = [ClassInfo]()
    
    
    // Look at each course in full queried class data
    for course in classData {
        
        // Look at each instructor for the course
        for instructor in course.instructors! {
            
            // Current database records use Null or empty string for no instructor
            if instructor != "Null" && instructor != "" {
                
                // Finds first ClassInfo in filtered with instructor
                if let index = filtered.firstIndex(where: { $0.instructors![0] == instructor }) {
                    print("Found!")
                    let prev = filtered[index]
                    filtered[index] = ClassInfo(term: prev.term, subjectCode: prev.subjectCode, courseCode: prev.courseCode, courseTitle: prev.courseTitle, instructors: prev.instructors, gradeInfo: combineGradeInfo(first: prev, second: course))
                // If wasnt found
                } else {
                    filtered.append(ClassInfo(term: course.term, subjectCode: course.subjectCode, courseCode: course.courseCode, courseTitle: course.courseTitle, instructors: [instructor], gradeInfo: course.gradeInfo))
                }
            }
        }
    }
    
    // Each class in array has 1 instructor, term is most recent
    return filtered
}
