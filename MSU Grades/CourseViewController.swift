//
//  CourseViewController.swift
//  MSU Grades
//
//  Created by Zach Arnold on 12/27/20.
//

import UIKit
import SearchTextField

class CourseViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate, UITableViewDataSource {
    
    // semesters to display in table view
    var semesters = [ClassInfo]()
    
    // instructors to display in table view
    var instructors = [ClassInfo]()
    
    // whether or not instructor view is toggled
    var instructorView = false
    
    // name of the course
    var courseName = ""

    @IBOutlet weak var breakdownButton: UIButton!
    @IBOutlet weak var courseTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Bottom of screen same color as background
        self.tableView.backgroundColor = view.backgroundColor
        
        
        // Initialize screen to instructor cells
        self.instructorView = true
        self.breakdownButton.setTitle("breakdown by Semester", for: .normal)
        
        // Height from top of screen to bottom of navigation bar
        let navigationBarHeight = self.navigationController?.navigationBar.frame.maxY
        
        // Height from bottom of navigation bar to bottom of screen
        let screenHeight = view.frame.size.height - navigationBarHeight!
        
        // Height form bottom of navigation bar to top of table
        let labelSpace = screenHeight / 4
        
        // Space to cushion labels from eachother / screen edges
        let labelCushion = view.frame.size.width / 30
        
        self.tableView.frame = CGRect(x: 0, y: navigationBarHeight! + screenHeight / 4, width: view.frame.size.width, height: screenHeight * 3 / 4)
        
        self.breakdownButton.frame = CGRect(x: view.frame.size.width / 2, y: navigationBarHeight! + labelSpace * 3 / 4, width: view.frame.size.width / 2 - labelCushion, height: labelSpace / 4)
        
        let font = UIFont(name: smallLabelFontName, size: view.frame.size.width * CGFloat(smallLabelFontConstant))
        
        self.breakdownButton.titleLabel?.font = font
        
        self.courseTitleLabel.frame = CGRect(x: labelCushion, y: navigationBarHeight! + labelCushion, width: view.frame.size.width - labelCushion * 2, height: labelSpace * 3/4 - labelCushion)
        
        self.courseTitleLabel.adjustsFontSizeToFitWidth = true
        self.courseTitleLabel.attributedText = createAttributedString(italic: self.courseName + " - Overview\n", bold: "Course Title: " + self.semesters[0].courseTitle, frameHeight: self.courseTitleLabel.frame.height)
        self.courseTitleLabel.lineBreakMode = .byTruncatingTail
        self.courseTitleLabel.textColor = UIColor.white
        self.courseTitleLabel.minimumScaleFactor = 0.5
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // return length of instructors or classes
        if self.instructorView {
            return instructors.count
        } else {
            return semesters.count
        }
    }
    
    // return cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return view.frame.size.width * 0.3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // use instructor cell in table view
        if self.instructorView {
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "InstructorCell") as! InstructorCell
            
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = UIColor(white: 0.2, alpha: 1.0)
            } else {
                cell.backgroundColor = UIColor(white: 0.25, alpha: 1.0)
            }
            
            // Space to cushion labels from eachother / screen edges
            let labelCushion = view.frame.size.width / 20
            
            // Height of cell
            let cellHeight = view.frame.size.width * 0.3
            
            // Width of cell
            let cellWidth = view.frame.size.width
       
            cell.instructorNameLabel.frame = CGRect(x: labelCushion, y: 0, width: cellWidth - labelCushion * 2, height: cellHeight / 2)
            
            cell.instructorNameLabel.adjustsFontSizeToFitWidth = true
            
            cell.averageLabel.frame = CGRect(x: labelCushion, y: cellHeight * 1/2, width: cellWidth / 2 - labelCushion, height: cellHeight / 5)
            
            cell.medianLabel.frame = CGRect(x: labelCushion, y: cellHeight * 7/10, width: cellWidth / 2 - labelCushion, height: cellHeight / 5)
            
            cell.totalStudentsLabel.frame = CGRect(x: cellWidth / 2, y: cellHeight * 1/2, width: cellWidth / 2 - labelCushion, height: cellHeight / 5)
            
            cell.latestDataLabel.frame = CGRect(x: cellWidth / 2, y: cellHeight * 7/10, width: cellWidth / 2 - labelCushion, height: cellHeight / 5)
            
            cell.averageLabel.font = cell.averageLabel.font.withSize(cellWidth * CGFloat(dataFontConstant))
            cell.medianLabel.font = cell.medianLabel.font.withSize(cellWidth * CGFloat(dataFontConstant))
            cell.totalStudentsLabel.font = cell.totalStudentsLabel.font.withSize(cellWidth * CGFloat(dataFontConstant))
            cell.latestDataLabel.font = cell.latestDataLabel.font.withSize(cellWidth * CGFloat(dataFontConstant))
            cell.instructorNameLabel.font = cell.instructorNameLabel.font.withSize(cellWidth * 0.075)
            
            // get data to display on cell
            let instructor = self.instructors[indexPath.row]
            let data = getGradeData(gpaMap: instructor.gradeInfo)
            let name = instructor.instructors![0]
            let latestTerm = instructor.term
            
            // edit attributes of cell to display or hold onto
            cell.instructorNameLabel.text = name
            
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
        
        // use semester cell in table view
        } else {
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "SemesterCell") as! SemesterCell
            
            setupSemesterCell(cell: cell, semesters: self.semesters, row: indexPath.row, cellWidth: view.frame.size.width)
            
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
                
                // Send instructor cell info if instructor view
                if self.instructorView {
                    let cell = self.tableView.cellForRow(at: indexPath) as! InstructorCell
                    let instructor = self.instructors[selectedRow].instructors![0]
                    
                    vc.chartTitle = instructor
                    vc.average = cell.gradeData.average
                    vc.median = cell.gradeData.median
                    vc.total = cell.gradeData.total
                    vc.gpaMap = self.instructors[selectedRow].gradeInfo
                    
                    // Hide detailed info button if looking at all instructors
                    if instructor == "All Instructors" {
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
                vc.boldedTitle = self.courseName
            }
        }
    }
    
    

    @IBAction func onBreakdownButton(_ sender: Any) {
        
        self.instructorView = !self.instructorView
        
        // Change title of breakdown button
        if self.instructorView {
            self.breakdownButton.setTitle("breakdown by Semester", for: .normal)
        } else {
            self.breakdownButton.setTitle("breakdown by Instructor", for: .normal)
        }
        // Reload table
        self.tableView.reloadData()
        
    }
}
