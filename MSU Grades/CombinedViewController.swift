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
    @IBOutlet weak var classOverviewButton: UIButton!
    @IBOutlet weak var instructorOverviewButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.backgroundColor = view.backgroundColor
        
        
        // Height from top of screen to bottom of navigation bar
        let navigationBarHeight = self.navigationController?.navigationBar.frame.maxY
        
        // Height from bottom of navigation bar to bottom of screen
        let screenHeight = view.frame.size.height - navigationBarHeight!
        
        // Height form bottom of navigation bar to top of table
        let labelSpace = screenHeight / 4
        
        // Space to cushion labels from eachother / screen edges
        let labelCushion = view.frame.size.width / 30
        
        self.tableView.frame = CGRect(x: 0, y: navigationBarHeight! + screenHeight / 4, width: view.frame.size.width, height: screenHeight * 3 / 4)
        
        self.classOverviewButton.frame = CGRect(x: labelCushion, y: navigationBarHeight! + labelSpace * 3 / 4, width: view.frame.size.width / 2 - labelCushion, height: labelSpace / 4)
        
        self.instructorOverviewButton.frame = CGRect(x: view.frame.size.width / 2, y: navigationBarHeight! + labelSpace * 3 / 4, width: view.frame.size.width / 2 - labelCushion, height: labelSpace / 4)
        
        let font = UIFont(name: smallLabelFontName, size: view.frame.size.width * CGFloat(smallLabelFontConstant))
        
        self.classOverviewButton.titleLabel?.font = font
        self.instructorOverviewButton.titleLabel?.font = font
        
        
        self.combinedTitleLabel.frame = CGRect(x: labelCushion, y: navigationBarHeight! + labelCushion, width: view.frame.size.width - labelCushion * 2, height: labelSpace * 3/4 - labelCushion)
        
        // Set up course title attributes
        let attributedString = NSMutableAttributedString(string: self.courseName + " / " + self.instructorName + "\n", attributes: [NSAttributedString.Key.font : UIFont.italicSystemFont(ofSize: self.combinedTitleLabel.frame.height * 1/3)])
        let boldAttributedString = NSMutableAttributedString(string: " - Overview", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: self.combinedTitleLabel.frame.height * 1/4)])
        
        attributedString.append(boldAttributedString)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6

        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        self.combinedTitleLabel.adjustsFontSizeToFitWidth = true
        self.combinedTitleLabel.attributedText = attributedString
        self.combinedTitleLabel.lineBreakMode = .byTruncatingTail
        self.combinedTitleLabel.textColor = UIColor.white
        self.combinedTitleLabel.minimumScaleFactor = 0.5
    }
    
    // Combined view only contains semester cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.semesters.count
    }
    
    
    // return cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return view.frame.size.width * 0.3
    }
    
    
    // Return semester cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SemesterCell") as! SemesterCell
        
        setupSemesterCell(cell: cell, semesters: self.semesters, row: indexPath.row, cellWidth: view.frame.size.width)
        
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
    

    // Send to class overview
    @IBAction func onClassOverview(_ sender: Any) {
        
        // Move to course view controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVc = storyboard.instantiateViewController(withIdentifier: "CourseViewController") as! CourseViewController
        
        // tokenize components
        let components = self.courseName.components(separatedBy: " ")
        
        // Query for instances of the class
        if let semesters = queryClasses(queryString: "SELECT * FROM courses WHERE subject_code == \"\(components[0])\" AND course_code == \"\(components[1])\";") {
            
            // filter by semester and instructors
            let filteredSemesters = filterBySemester(classData: semesters)
            let filteredInstructors = filterByInstructor(classData: semesters)
            newVc.semesters = filteredSemesters
            newVc.instructors = filteredInstructors
            
        }
        
        newVc.courseName = self.courseName
        
        var vcArray = self.navigationController?.viewControllers
        vcArray!.removeLast()
        vcArray!.removeLast()
        vcArray!.removeLast()
        vcArray!.append(newVc)
        self.navigationController?.setViewControllers(vcArray!, animated: true)
    }
    
    
    // Send to instructor overview
    @IBAction func onInstructorOverview(_ sender: Any) {
        
        // Move to instructor view controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVc = storyboard.instantiateViewController(withIdentifier: "InstructorViewController") as! InstructorViewController
        
        let instructor = self.instructorName
        
        let instructorSecondary = instructorComma(original: instructor)
        
        let instructorTertiary = instructorCommaAlternate(original: instructor)
        
        // Query for instances of the instructor
        if let semesters = queryClasses(queryString: "SELECT * FROM courses WHERE instructors LIKE \"%\(instructor)%\" OR instructors LIKE \"%\(instructorSecondary)%\" OR instructors LIKE \"%\(instructorTertiary)%\";") {
            
            // filter out semesters and courses from queried data
            let filteredSemesters = filterBySemester(classData: semesters)
            let filteredCourses = filterByCourse(classData: semesters)
            
            newVc.semesters = filteredSemesters
            newVc.courses = filteredCourses
        }
        
        newVc.instructorName = instructor
        
        var vcArray = self.navigationController?.viewControllers
        vcArray!.removeLast()
        vcArray!.removeLast()
        vcArray!.removeLast()
        vcArray!.append(newVc)
        self.navigationController?.setViewControllers(vcArray!, animated: true)
    }
}
