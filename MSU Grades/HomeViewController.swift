//
//  HomeViewController.swift
//  MSU Grades
//
//  Created by Zach Arnold on 12/21/20.
//

import UIKit
import SearchTextField
import Charts

class HomeViewController: UIViewController, UITextFieldDelegate, ChartViewDelegate {


    @IBOutlet weak var classSearchBar: SearchTextField!
    @IBOutlet weak var appNameLabel: UILabel!
    
    
    // List of text view suggestions and animated bar chart
    var suggestions = [String]()
    var barChart = BarChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.barChart.delegate = self
        self.classSearchBar.delegate = self
        
        // DARK MODEEE
        self.classSearchBar.keyboardAppearance = .dark
        
        // navigation item setup
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.13, green: 0.36, blue: 0.31, alpha: 1.00)
        
        // put search bar in navigation item
        self.classSearchBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width * 0.8, height: 20)
        self.navigationItem.titleView = self.classSearchBar

        
        // Set app name label
        self.appNameLabel.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width * 0.875, height: self.view.frame.size.width * 0.4)
        self.appNameLabel.center = CGPoint(x: view.center.x, y: view.center.y + self.view.frame.size.width * 0.45)
        self.appNameLabel.adjustsFontSizeToFitWidth = true
        
        self.setupSearchBar()
    }
    
    
    // Called when 'return' key pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // Called when the user click on the view outside of text field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.classSearchBar.resignFirstResponder()
    }
    
    // To set up bar chart on home page
    override func viewDidLayoutSubviews() {
        
        // Set frames of chart
        self.barChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width * 0.9375, height: self.view.frame.size.width)
        
        // Set center of chart
        self.barChart.center = CGPoint(x: view.center.x, y: view.center.y - view.frame.size.height * 0.0625)

        view.addSubview(barChart)
        
        // Set up initial values for bar chart info
        let chartData = BarChartDataSet()
        var chartColors = [UIColor]()
        
        chartData.append(BarChartDataEntry(x: 0, y: 3))
        chartData.append(BarChartDataEntry(x: 1, y: 5))
        chartData.append(BarChartDataEntry(x: 2, y: 4))
        chartData.append(BarChartDataEntry(x: 3, y: 1))
        
        chartColors.append(gpaColors["4.0"]!)
        chartColors.append(gpaColors["3.0"]!)
        chartColors.append(gpaColors["2.0"]!)
        chartColors.append(gpaColors["0.0"]!)
        
        chartData.colors = chartColors
        chartData.drawValuesEnabled = false
        
        self.barChart.data = BarChartData(dataSet: chartData)
        
        self.barChart.xAxis.enabled = false
        self.barChart.leftAxis.enabled = false
        self.barChart.rightAxis.enabled = false
        self.barChart.drawGridBackgroundEnabled = false
        self.barChart.isUserInteractionEnabled = false
        self.barChart.legend.enabled = false
        
        // Chart should not ever go negative
        self.barChart.leftAxis.axisMinimum = 0
        self.barChart.rightAxis.axisMinimum = 0
        
        self.barChart.animate(yAxisDuration: 1.0)
    }
    
    
    func setupSearchBar() {
        self.classSearchBar.backgroundColor = UIColor(red: 0.13, green: 0.36, blue: 0.31, alpha: 1.00)
        
        // find suggestions
        if let found = querySearchSuggestions(queryCoursesString: "SELECT subject_code, course_code, course_title FROM courses GROUP BY subject_code, course_code;", queryInstructorsString: "SELECT DISTINCT instructors FROM courses;") {
            self.suggestions = found
            
            // errorous data
            if let index = self.suggestions.firstIndex(of: "Saul Beceiro Novo") {
                self.suggestions.remove(at: index)
            }
            self.classSearchBar.filterStrings(self.suggestions)
        }
        
        // DARK MODEEE
        self.classSearchBar.theme = .darkTheme()
        
        self.classSearchBar.theme.font = UIFont.systemFont(ofSize: 14)
        self.classSearchBar.theme.bgColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.975)
        self.classSearchBar.theme.borderColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 0.975)
        self.classSearchBar.theme.separatorColor = UIColor (red: 0.7, green: 0.7, blue: 0.7, alpha: 0.975)
        self.classSearchBar.theme.cellHeight = 40
        
        self.classSearchBar.tableCornerRadius = 5
        
        
        // Set up magnifying glass in search bar
        let xPadding = 10
        let yPadding = 1
        let xMagSize = 20
        let yMagSize = 18

        let magnifyingGlassImage = UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))?.withTintColor(.white, renderingMode: .alwaysOriginal)
        
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: xMagSize + xPadding, height: xMagSize) )
        let iconView  = UIImageView(frame: CGRect(x: xPadding, y: yPadding, width: xMagSize, height: yMagSize))
    
        iconView.image = magnifyingGlassImage
        outerView.addSubview(iconView)

        self.classSearchBar.leftViewMode = .always
        self.classSearchBar.leftView = outerView
        
        
        // Set up bar corner radius
        self.classSearchBar.layer.cornerRadius = self.classSearchBar.frame.size.height/2
        self.classSearchBar.clipsToBounds = true
        self.classSearchBar.adjustsFontSizeToFitWidth = true
        
        
        // Handle item selection - Default behaviour: item title set to the text field
        self.classSearchBar.itemSelectionHandler = { filteredResults, itemPosition in
            // Just in case you need the item position
            let item = filteredResults[itemPosition]
            
            self.classSearchBar.resignFirstResponder()

            // Do whatever you want with the picked item
            self.classSearchBar.text = item.title
            
            // Check whether or not selected item contains digits
            // Assumes instructor names do not have digits
            if item.title.rangeOfCharacter(from: .decimalDigits) != nil {
                self.performSegue(withIdentifier: "courseSegue", sender: nil)
            } else {
                self.performSegue(withIdentifier: "instructorSegue", sender: nil)
            }
            
            self.classSearchBar.text = ""
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // if segue is to course page
        if segue.identifier == "courseSegue" {
            
            // destination is course view controller
            let vc = segue.destination as! CourseViewController
            
            // tokenize components
            let components = self.classSearchBar.text!.components(separatedBy: " ")
            
            // pass the semesters to course view to put in table
            if let semesters = queryClasses(queryString: "SELECT * FROM courses WHERE subject_code == \"\(components[0])\" AND course_code == \"\(components[1])\";") {
                
                // filter out semesters and instructors from queried data
                let filteredSemesters = filterBySemester(classData: semesters)
                let filteredInstructors = filterByInstructor(classData: semesters)
                
                vc.semesters = filteredSemesters
                vc.instructors = filteredInstructors
            }
            
            vc.courseName = components[0] + " " + components[1]
        } else if segue.identifier == "instructorSegue" {
            
            // destination is instructor view controller
            let vc = segue.destination as! InstructorViewController
            
            let instructor = self.classSearchBar.text!
            
            let instructorSecondary = instructorComma(original: instructor)
            
            let instructorTertiary = instructorCommaAlternate(original: instructor)
            
            if let semesters = queryClasses(queryString: "SELECT * FROM courses WHERE instructors LIKE \"%\(instructor)%\" OR instructors LIKE \"%\(instructorSecondary)%\" OR instructors LIKE \"%\(instructorTertiary)%\";") {
                
                // filter out semesters and courses from queried data
                let filteredSemesters = filterBySemester(classData: semesters)
                let filteredCourses = filterByCourse(classData: semesters)
                
                vc.semesters = filteredSemesters
                vc.courses = filteredCourses
            }
            
            vc.instructorName = instructor
        }
    }

}
