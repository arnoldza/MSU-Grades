//
//  ChartViewController.swift
//  MSU Grades
//
//  Created by Zach Arnold on 12/22/20.
//

import UIKit
import Charts


class ChartViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var averageGradeLabel: UILabel!
    @IBOutlet weak var medianGradeLabel: UILabel!
    @IBOutlet weak var totalGradesLabel: UILabel!
    @IBOutlet weak var chartControl: UISegmentedControl!
    
    // Ordering of elements in chart
    let chartOrder = ["4.0", "3.5", "3.0", "2.5", "2.0", "1.5", "1.0", "0.0",
                        "A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D+",
                        "D", "D-", "F",
                        "incomplete", "withdrawn", "pass", "no_grade", "deferred",
                        "unfinished_work", "visitor", "auditor", "extension",
                        "conditional_pass", "no_grade_reported", "blank"]
    
    // Map of gpa values to total num
    let gpaMap = ["4.0": 195, "3.5": 98, "3.0": 70, "2.5": 45,
                  "2.0": 64, "1.5": 21, "1.0": 44, "0.0": 108,
                  "A+" : 0, "A" : 0, "A-" : 0, "B+" : 0, "B" : 0, "B-" : 0,
                  "C+" : 0, "C" : 0, "C-" : 0, "D+" : 0, "D" : 0, "D-" : 0,
                  "F" : 0,
                  "incomplete" : 0, "withdrawn" : 0, "pass" : 0, "no_grade" : 0,
                  "deferred" : 0, "unfinished_work" : 14, "visitor" : 0,
                  "auditor" : 0, "extension" : 0, "conditional_pass" : 66,
                  "no_grade_reported" : 23, "blank" : 0]
    
    // Map of colors of each chart segment
    // White color implies no current entries
    let gpaColors = ["4.0" : UIColor(red: 0.39, green: 0.75, blue: 0.48, alpha: 0.90),
                     "3.5" : UIColor(red: 0.42, green: 0.78, blue: 0.40, alpha: 0.90),
                     "3.0" : UIColor(red: 0.56, green: 0.81, blue: 0.40, alpha: 0.90),
                     "2.5" : UIColor(red: 0.72, green: 0.84, blue: 0.40, alpha: 0.90),
                     "2.0" : UIColor(red: 0.87, green: 0.85, blue: 0.40, alpha: 0.90),
                     "1.5" : UIColor(red: 0.91, green: 0.73, blue: 0.41, alpha: 0.90),
                     "1.0" : UIColor(red: 0.94, green: 0.57, blue: 0.41, alpha: 0.90),
                     "0.0" : UIColor(red: 0.97, green: 0.41, blue: 0.42, alpha: 0.90),
                     "A+" : UIColor.white,
                     "A" : UIColor(red: 0.48, green: 0.74, blue: 0.51, alpha: 0.90),
                     "A-" : UIColor(red: 0.49, green: 0.76, blue: 0.45, alpha: 0.90),
                     "B+" : UIColor(red: 0.54, green: 0.78, blue: 0.44, alpha: 0.90),
                     "B" : UIColor(red: 0.61, green: 0.80, blue: 0.45, alpha: 0.90),
                     "B-" : UIColor(red: 0.68, green: 0.82, blue: 0.46, alpha: 0.90),
                     "C+" : UIColor(red: 0.76, green: 0.84, blue: 0.46, alpha: 0.90),
                     "C" : UIColor(red: 0.86, green: 0.87, blue: 0.47, alpha: 0.90),
                     "C-" : UIColor(red: 0.87, green: 0.80, blue: 0.46, alpha: 0.90),
                     "D+" : UIColor(red: 0.88, green: 0.72, blue: 0.45, alpha: 0.90),
                     "D" : UIColor(red: 0.88, green: 0.63, blue: 0.44, alpha: 0.90),
                     "D-" : UIColor.white,
                     "F" : UIColor(red: 0.90, green: 0.45, blue: 0.44, alpha: 0.90),
                     "incomplete" : UIColor(red: 0.53, green: 0.33, blue: 0.55, alpha: 0.90),
                     "withdrawn" : UIColor(red: 0.92, green: 0.22, blue: 0.17, alpha: 0.90),
                     "pass" : UIColor(red: 0.48, green: 0.74, blue: 0.51, alpha: 0.90),
                     "no_grade" : UIColor(red: 0.90, green: 0.45, blue: 0.44, alpha: 0.90),
                     "deferred" : UIColor(red: 0.96, green: 0.71, blue: 0.45, alpha: 0.90),
                     "unfinished_work" : UIColor(red: 0.52, green: 0.10, blue: 0.55, alpha: 0.90),
                     "visitor" : UIColor(red: 0.03, green: 0.04, blue: 0.55, alpha: 0.90),
                     "auditor" : UIColor(red: 0.25, green: 0.27, blue: 0.60, alpha: 0.90),
                     "extension" : UIColor(red: 0.93, green: 0.41, blue: 0.17, alpha: 0.90),
                     "conditional_pass" : UIColor(red: 0.95, green: 0.65, blue: 0.44, alpha: 0.90),
                     "no_grade_reported" : UIColor(red: 0.50, green: 0.50, blue: 0.50, alpha: 0.90),
                     "blank" : UIColor(red: 0.59, green: 0.59, blue: 0.59, alpha: 0.90)]

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
        
        // Control which chart to show
        if self.chartControl.selectedSegmentIndex == 0 {
            self.barChart.isHidden = false
            self.pieChart.isHidden = true
        } else {
            self.barChart.isHidden = true
            self.pieChart.isHidden = false
        }
        
        // Set frames of charts
        barChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width * 1.1)
        pieChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        
        // Set centers of charts
        barChart.center = CGPoint(x: view.center.x, y: view.center.y + view.frame.size.height / 16)
        pieChart.center = CGPoint(x: view.center.x, y: view.center.y + view.frame.size.height / 16)
        
        view.addSubview(barChart)
        view.addSubview(pieChart)
        
        // Set values of grade data labels
        let gradeData = getGradeData()
        averageGradeLabel.text = "Average Grade = " + String(format: "%.3f", gradeData.average)
        medianGradeLabel.text = "Median Grade = " + gradeData.median
        totalGradesLabel.text = String(gradeData.total) + " total students"
        
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
        for val in self.chartOrder {
            
            // Only add values to bar chart if value greater than 0
            if self.gpaMap[val] != 0 {
                chartData.append(BarChartDataEntry(x: Double(index), y: Double(self.gpaMap[val]!)))
                chartColors.append(self.gpaColors[val]!)
                
                // If label is short, show under bar, otherwise add to legend
                if val.count <= 4 {
                    valueFormatter.append(val)
                } else {
                    let entry = LegendEntry(label: val, form: .default, formSize: CGFloat.nan, formLineWidth: CGFloat.nan, formLineDashPhase: CGFloat.nan, formLineDashLengths: nil, formColor: self.gpaColors[val])
                    legendEntries.append(entry)
                    valueFormatter.append("")
                }
                index += 1
            }
        }
        
        chartData.colors = chartColors
        
        // Legend information
        self.barChart.legend.setCustom(entries: legendEntries)
        self.barChart.legend.xEntrySpace = 15
        self.barChart.legend.textColor = UIColor.white
        self.barChart.legend.form = .circle
        
        // Data information
        self.barChart.data = BarChartData(dataSet: chartData)
        self.barChart.data?.setValueTextColor(UIColor.white)

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
        for val in self.chartOrder {
            // Only add values to pie chart if value greater than 0
            if self.gpaMap[val] != 0 {
                chartData.append(PieChartDataEntry(value: Double(self.gpaMap[val]!), label: val))
                chartColors.append(self.gpaColors[val]!)
            }
        }
        
        chartData.colors = chartColors
        chartData.label = ""
        
        // Legend information
        self.pieChart.legend.textColor = UIColor.white
        self.pieChart.legend.xEntrySpace = 15
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
    
    
    
    func getGradeData() ->
        (average: Double, median: String, total: Int) {
        
        // Get total students
        let totalStudents = Array(self.gpaMap.values).reduce(0, +)
        
        // Weights for averages
        let weightsMap = ["4.0": 4.0, "3.5": 3.5, "3.0": 3.0, "2.5": 2.5,
                          "2.0": 2.0, "1.5": 1.5, "1.0": 1.0, "0.0": 0.0,
                          "A+" : 4.0, "A" : 4.0, "A-" : 3.67, "B+" : 3.33,
                          "B" : 3.0, "B-" : 2.67, "C+" : 2.33, "C" : 2.0,
                          "C-" : 1.67, "D+" : 1.33, "D" : 1.0, "D-" : 0.67,
                          "F" : 0.0]
        
        var averageNum = 0.0
        var totalGrades = 0
        
        for (key, val) in weightsMap {
            averageNum += Double(self.gpaMap[key]!) * val
            totalGrades += Int(self.gpaMap[key]!)
        }
        
        var averageGrade = -1.0
        var medianGrade = ""
        
        // If there are grades to get data on
        if totalGrades != 0 {
            // Get average
            averageGrade = averageNum / Double(totalGrades)
            
            // Get median
            var totalSeen = 0
            for val in ["0.0", "1.0", "1.5", "2.0", "2.5", "3.0", "3.5", "4.0"] {
                totalSeen += self.gpaMap[val]!
                
                if totalSeen > totalGrades / 2 {
                    medianGrade = val
                    break
                }
            }
            
            if totalSeen == 0 {
                // Get median letter grade if no regular median
                for val in ["F", "D-", "D", "D+", "C-", "C", "C+", "B-", "B",
                            "B+", "A-", "A", "A+"] {
                    totalSeen += self.gpaMap[val]!
                    
                    if totalSeen > totalGrades / 2 {
                        medianGrade = val
                        break
                    }
                }
            }
        }
    
        return (average: averageGrade, median: medianGrade, total: totalStudents)
    }
    

    
    @IBAction func changeChart(_ sender: Any) {
        self.barChart.isHidden = !self.barChart.isHidden
        self.pieChart.isHidden = !self.pieChart.isHidden
    }
    

}


