//
//  CombinedViewController.swift
//  MSU Grades
//
//  Created by Zach Arnold on 12/28/20.
//

import UIKit

class CombinedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    // semesters to display in table view
    var semesters = [ClassInfo]()
    
    // name of the course
    var courseName = ""
    
    // name of the instructor
    var instructorName = ""
    
    @IBOutlet weak var combinedTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.backgroundColor = view.backgroundColor
        
        combinedTitleLabel.text = self.courseName + " / " + self.instructorName + " - Overview"
    }
    
    // Combined view only contains semester cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.semesters.count
    }
    
    // Return semester cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SemesterCell") as! SemesterCell
        
        setupSemesterCell(cell: cell, semesters: self.semesters, row: indexPath.row)
        
        return cell
    }
    
    // segues to chart
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
                
                // Send semester cell info
                let cell = self.tableView.cellForRow(at: indexPath) as! SemesterCell
                vc.chartTitle = self.semesters[selectedRow].term
                vc.average = cell.gradeData.average
                vc.median = cell.gradeData.median
                vc.total = cell.gradeData.total
                vc.gpaMap = self.semesters[selectedRow].gradeInfo
                vc.detailedInfoButtonHide = true
                vc.boldedTitle = self.courseName + " / " + self.instructorName
            }
        }
    }
    

    @IBAction func onClassOverview(_ sender: Any) {
        
    }
    
    
    @IBAction func onInstructorOverview(_ sender: Any) {
    }
}
