//
//  CourseViewController.swift
//  MSU Grades
//
//  Created by Zach Arnold on 12/27/20.
//

import UIKit

class CourseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // semesters to display in table view
    var semesters = [ClassInfo]()
    
    // name of the course
    var courseName = ""

    @IBOutlet weak var courseTitleLabel: UILabel!
    @IBOutlet weak var courseDescriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.backgroundColor = view.backgroundColor
        
        self.courseTitleLabel.text = self.courseName + " - Overview"
        
        // Get most recent title of course
        self.courseDescriptionLabel.text = "Course Title: " + self.semesters[0].courseTitle
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return semesters.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // use semester cell in table view
        let cell = tableView.dequeueReusableCell(withIdentifier: "SemesterCell") as! SemesterCell
        
        cell.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
        
        // get data to display on cell
        let semester = self.semesters[indexPath.row]
        let data = getGradeData(gpaMap: semester.gradeInfo)
        let term = semester.term
        
        // edit attributes of cell to display or hold onto
        cell.semesterLabel.text = term
        cell.averageLabel.text = "Average Grade = " + String(format: "%.3f", data.average)
        cell.medianLabel.text = "MedianGrade = " + data.median
        cell.gradeData = data
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
                let cell = self.tableView.cellForRow(at: indexPath) as! SemesterCell
                
                // edit attributes of chart view
                vc.gpaMap = self.semesters[selectedRow].gradeInfo
                vc.chartTitle = self.semesters[selectedRow].term
                vc.courseName = self.courseName
                vc.average = cell.gradeData.average
                vc.median = cell.gradeData.median
                vc.total = cell.gradeData.total
                
            }
        }
    }

}
