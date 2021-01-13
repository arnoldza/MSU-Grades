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
    
    // First course in array
    let first = classData[0]

    filtered.append(ClassInfo(term: "All Semesters", subjectCode: first.term, courseCode: first.term, courseTitle: first.courseTitle, instructors: nil, gradeInfo: first.gradeInfo))
    
    // Look at each course in full queried class data
    for (i, course) in classData.enumerated() {
        
        // If this semester hasnt been seen yet
        if filtered.last!.term != course.term {
            filtered.append(ClassInfo(term: course.term, subjectCode: course.subjectCode, courseCode: course.courseCode, courseTitle: course.courseTitle, instructors: nil, gradeInfo: course.gradeInfo))
        } else {
            let prev = filtered[filtered.count - 1]
            filtered[filtered.count - 1] = ClassInfo(term: prev.term, subjectCode: prev.subjectCode, courseCode: prev.courseCode, courseTitle: prev.courseTitle, instructors: nil, gradeInfo: combineGradeInfo(first: prev, second: course))
        }
        
        // Get all semesters
        if i != 0 {
            filtered[0] = ClassInfo(term: "All Semesters", subjectCode: filtered[0].subjectCode, courseCode: filtered[0].courseCode, courseTitle: filtered[0].courseTitle, instructors: nil, gradeInfo: combineGradeInfo(first: filtered[0], second: course))
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
    
    // First course in array
    let first = classData[0]
    
    filtered.append(ClassInfo(term: first.term, subjectCode: first.subjectCode, courseCode: first.courseCode, courseTitle: first.courseTitle, instructors: ["All Instructors"], gradeInfo: first.gradeInfo))
    
    // Look at each course in full queried class data
    for (i, course) in classData.enumerated() {
        
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
        
        // Get all semesters
        if i != 0 {
            filtered[0] = ClassInfo(term: filtered[0].term, subjectCode: filtered[0].subjectCode, courseCode: filtered[0].courseCode, courseTitle: filtered[0].courseTitle, instructors: ["All Instructors"], gradeInfo: combineGradeInfo(first: filtered[0], second: course))
        }
    }
    
    // Each class in array has 1 instructor, term is most recent
    return filtered
}
