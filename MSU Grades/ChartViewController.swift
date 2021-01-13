//
//  ChartViewController.swift
//  MSU Grades
//
//  Created by Zach Arnold on 12/22/20.
//

import UIKit
import Charts


class ChartViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var averageGradeLabel: UILabel!
    @IBOutlet weak var medianGradeLabel: UILabel!
    @IBOutlet weak var totalGradesLabel: UILabel!
    @IBOutlet weak var chartControl: UISegmentedControl!
    @IBOutlet weak var detailedInfoButton: UIButton!
    
    // Info passed through table view cell
    var gpaMap = [String : Int]()
    var chartTitle = ""
    var boldedTitle = ""
    var average = -1.0
    var median = ""
    var total = 0
    var detailedInfoButtonHide = false
    

    // Chart views
    var barChart = BarChartView()
    var pieChart = PieChartView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.barChart.delegate = self
        self.pieChart.delegate = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Whether or not to hide detailed grade info button
        if self.detailedInfoButtonHide {
            self.detailedInfoButton.isHidden = true
        }
        
        // Control which chart to show
        if self.chartControl.selectedSegmentIndex == 0 {
            self.barChart.isHidden = false
            self.pieChart.isHidden = true
        } else {
            self.barChart.isHidden = true
            self.pieChart.isHidden = false
        }
        
        // Set frames of charts
        self.barChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        self.pieChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        
        // Set centers of charts
        barChart.center = CGPoint(x: view.center.x, y: view.center.y + view.frame.size.height * (5/64))
        pieChart.center = CGPoint(x: view.center.x, y: view.center.y + view.frame.size.height * (5/64))
        
        view.addSubview(barChart)
        view.addSubview(pieChart)
        
        // Set values of grade data labels
        if self.average >= 0 {
            averageGradeLabel.text = "Average Grade = " + String(format: "%.3f", self.average)
        } else {
            averageGradeLabel.text = ""
        }
        if self.median != "" {
            medianGradeLabel.text = "Median Grade = " + self.median
        } else {
            medianGradeLabel.text = ""
        }
        totalGradesLabel.text = String(self.total) + " total students"
        
        
        // Set up chart title attributes
        let attributedString = NSMutableAttributedString(string: self.chartTitle + "\n", attributes: [NSAttributedString.Key.font : UIFont.italicSystemFont(ofSize: 32)])
        let boldAttributedString = NSMutableAttributedString(string: self.boldedTitle, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 27)])

        attributedString.append(boldAttributedString)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6

        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        self.titleLabel.attributedText = attributedString
        self.titleLabel.adjustsFontSizeToFitWidth = true
        self.titleLabel.textColor = UIColor.white
        self.titleLabel.minimumScaleFactor = 0.5
        
        
        // Set chart specs
        self.setBarChart()
        self.setPieChart()
        
    }
    
    
    func setBarChart() {
        
        // Set up initial values for bar chart info
        let chartData = BarChartDataSet()
        var chartColors = [UIColor]()
        var valueFormatter = [String]()
        var legendEntries = [LegendEntry]()
        
        
        var index = 0
        for val in chartOrder {
            
            // Only add values to bar chart if value greater than 0
            if self.gpaMap[val] != 0 {
                chartData.append(BarChartDataEntry(x: Double(index), y: Double(self.gpaMap[val]!)))
                chartColors.append(gpaColors[val]!)
                
                // If label is short, show under bar, otherwise add to legend
                if val.count <= 4 {
                    valueFormatter.append(val)
                } else {
                    let entry = LegendEntry(label: val, form: .default, formSize: CGFloat.nan, formLineWidth: CGFloat.nan, formLineDashPhase: CGFloat.nan, formLineDashLengths: nil, formColor: gpaColors[val])
                    legendEntries.append(entry)
                    valueFormatter.append("")
                }
                index += 1
            }
        }
        
        chartData.colors = chartColors
        chartData.valueFont = UIFont.systemFont(ofSize: 10)
        
        // Legend information
        self.barChart.legend.setCustom(entries: legendEntries)
        self.barChart.legend.xEntrySpace = 15
        self.barChart.legend.yEntrySpace = 8
        self.barChart.legend.textColor = UIColor.white
        self.barChart.legend.form = .circle
        
        // Data information
        self.barChart.data = BarChartData(dataSet: chartData)
        self.barChart.data?.setValueTextColor(UIColor.white)
        // Formatter for values
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        self.barChart.data?.setValueFormatter(DefaultValueFormatter(formatter:formatter))

        // X Axis information
        self.barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: valueFormatter)
        self.barChart.xAxis.labelTextColor = UIColor.white
        self.barChart.xAxis.labelPosition = .bottom
        self.barChart.xAxis.labelCount = valueFormatter.count
        self.barChart.xAxis.avoidFirstLastClippingEnabled = false
        
        // Y Axis information
        self.barChart.leftAxis.labelTextColor = UIColor.white
        self.barChart.rightAxis.enabled = false
        // Chart should not ever go negative
        self.barChart.leftAxis.axisMinimum = 0
        self.barChart.rightAxis.axisMinimum = 0
        
        // Other
        self.barChart.isUserInteractionEnabled = false
        self.barChart.animate(yAxisDuration: 1.0)
        self.barChart.extraBottomOffset = 10.0
    
    }
    
 
    func setPieChart() {
        
        // Set up initial values for pie chart info
        let chartData = PieChartDataSet()
        var chartColors = [UIColor]()
        
        // Get chart data
        for val in chartOrder {
            // Only add values to pie chart if value greater than 0
            if self.gpaMap[val] != 0 {
                chartData.append(PieChartDataEntry(value: Double(self.gpaMap[val]!), label: val))
                chartColors.append(gpaColors[val]!)
            }
        }
        
        chartData.colors = chartColors
        chartData.label = ""
        
        // Legend information
        self.pieChart.legend.textColor = UIColor.white
        self.pieChart.legend.xEntrySpace = 15
        self.pieChart.legend.yEntrySpace = 8
        self.pieChart.legend.form = .circle
        self.pieChart.legend.horizontalAlignment = .center
        
        // Data information
        self.pieChart.data = PieChartData(dataSet: chartData)
        // Formatter for values
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        self.pieChart.data?.setValueFormatter(DefaultValueFormatter(formatter:formatter))
        
        // Other
        self.pieChart.holeColor = self.view.backgroundColor
        self.pieChart.highlightPerTapEnabled = false
        self.pieChart.drawEntryLabelsEnabled = false
    }
    

    // On change of chart control, charts switch place
    @IBAction func changeChart(_ sender: Any) {
        self.barChart.isHidden = !self.barChart.isHidden
        self.pieChart.isHidden = !self.pieChart.isHidden
    }
    
    
    @IBAction func onDetailedInfoButton(_ sender: Any) {
        
        // Move to combined view controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVc = storyboard.instantiateViewController(withIdentifier: "CombinedViewController") as! CombinedViewController
        
        // Get query components
        let instructor = self.chartTitle
        let instructorSecondary = instructorComma(original: instructor)
        let courseName = self.boldedTitle
        let courseComponents = courseName.components(separatedBy: " ")
        
        // Query for instances of both the course and instructor that taught
        if let semesters = queryClasses(queryString: "SELECT * FROM courses WHERE subject_code == \"\(courseComponents[0])\" AND course_code == \"\(courseComponents[1])\" AND (instructors LIKE \"%\(instructor)%\" OR instructors LIKE \"%\(instructorSecondary)%\");") {
            
            // filter by semester and return
            let filtered = filterBySemester(classData: semesters)
            newVc.semesters = filtered
        }
        
        // Set attributes of new view controller
        newVc.courseName = courseName
        newVc.instructorName = instructor
        
        var vcArray = self.navigationController?.viewControllers
        vcArray!.removeLast()
        vcArray!.removeLast()
        vcArray!.append(newVc)
        self.navigationController?.setViewControllers(vcArray!, animated: true)
    }
    
}


