//
//  InstructorViewController.swift
//  MSU Grades
//
//  Created by Zach Arnold on 12/28/20.
//

import UIKit

class InstructorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    // semesters to display in table view
    var semesters = [ClassInfo]()
    
    // instructors to display in table view
    var courses = [ClassInfo]()
    
    // whether or not course view is toggled
    var courseView = false
    
    // name of the instructor
    var instructorName = ""
    
    @IBOutlet weak var breakdownButton: UIButton!
    @IBOutlet weak var instructorNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Bottom of screen same color as background
        self.tableView.backgroundColor = view.backgroundColor
        
        self.instructorNameLabel.text = self.instructorName + " (Instructor) - Overview"
        
        self.courseView = true
        self.breakdownButton.setTitle("breakdown by Semester", for: .normal)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.courseView {
            return courses.count
        } else {
            return semesters.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.courseView {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "CourseCell") as! CourseCell
            
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = UIColor(white: 0.2, alpha: 1.0)
            } else {
                cell.backgroundColor = UIColor(white: 0.25, alpha: 1.0)
            }
            
            // get data to display on cell
            let course = self.courses[indexPath.row]
            let data = getGradeData(gpaMap: course.gradeInfo)
            let courseName = course.subjectCode + " " + course.courseCode
            let courseTitle = course.courseTitle
            let latestTerm = course.term
            
            cell.courseTitleLabel.text = courseName
            
            if courseTitle != "" {
                cell.courseTitleLabel.text! += " - " + courseTitle
            }
            
            if data.average >= 0 {
                cell.averageLabel.text = "Average Grade = " + String(format: "%.3f", data.average)
            } else {
                cell.averageLabel.text = "Average Grade = N/A"
            }
            if data.median != "" {
                cell.medianLabel.text = "Median Grade = " + data.median
            } else {
                cell.medianLabel.text = "Median Grade = N/A"
            }
            cell.totalStudentsLabel.text = String(data.total) + " total students"
            cell.latestDataLabel.text = "Latest Data: " + latestTerm
            cell.gradeData = data
            
            return cell
            
        } else {
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "SemesterCell") as! SemesterCell
            
            setupSemesterCell(cell: cell, semesters: self.semesters, row: indexPath.row)
            
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // segue to chart
        performSegue(withIdentifier: "chartSegue", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // overrides the prepare segue function
    // used to pass information from this view to chart
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // if we're moving to chart view
        if segue.identifier == "chartSegue" {
            
            // get indexpath of selected cell
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                // get row, cell and view controller to pass info from / to
                let selectedRow = indexPath.row
                let vc = segue.destination as! ChartViewController
                
                // Send course cell info if instructor view
                if self.courseView {
                    let cell = self.tableView.cellForRow(at: indexPath) as! CourseCell
                    
                    let courseName = self.courses[selectedRow].subjectCode + " " + self.courses[selectedRow].courseCode
                    
                    vc.chartTitle = courseName
                    
                    vc.average = cell.gradeData.average
                    vc.median = cell.gradeData.median
                    vc.total = cell.gradeData.total
                    
                    vc.gpaMap = self.courses[selectedRow].gradeInfo
                    
                    // Hide detailed info button if looking at all courses
                    if courseName == "All Courses" {
                        vc.detailedInfoButtonHide = true
                    } else {
                        vc.detailedInfoButtonHide = false
                    }
                    
                // Send semester cell info otherwise
                } else {
                    let cell = self.tableView.cellForRow(at: indexPath) as! SemesterCell
                    vc.chartTitle = self.semesters[selectedRow].term
                    vc.average = cell.gradeData.average
                    vc.median = cell.gradeData.median
                    vc.total = cell.gradeData.total
                    vc.gpaMap = self.semesters[selectedRow].gradeInfo
                    vc.detailedInfoButtonHide = true
                }
                vc.boldedTitle = self.instructorName
            }
        }
    }
    
    
    @IBAction func onBreakdownButton(_ sender: Any) {
        
        self.courseView = !self.courseView
        
        // Change title of breakdown button
        if self.courseView {
            self.breakdownButton.setTitle("breakdown by Semester", for: .normal)
        } else {
            self.breakdownButton.setTitle("breakdown by Course", for: .normal)
        }
        // Reload table
        self.tableView.reloadData()
        
    }
    

}
