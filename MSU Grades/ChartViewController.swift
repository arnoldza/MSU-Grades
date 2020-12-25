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
    
    // Array of gpas
    let gpaArray = ["4.0", "3.5", "3.0", "2.5", "2.0", "1.5", "1.0", "0.0"]
    
    // Array of total nums
    let gpaCounts = [195, 98, 70, 45, 64, 21, 44, 108]
    
    // Tuple of gpa values to total num
    let gpaTuples = [("4.0", 195), ("3.5", 98), ("3.0", 70), ("2.5", 45),
                     ("2.0", 64), ("1.5", 21), ("1.0", 44), ("0.0", 108)]
    
    // Tuple of gpa values to total num
    let gpaMap = ["4.0": 195, "3.5": 98, "3.0": 70, "2.5": 45,
                  "2.0": 64, "1.5": 21, "1.0": 44, "0.0": 108]
    
    // Colors of each chart segment
    let gpaColors = [UIColor(red: 0.39, green: 0.75, blue: 0.48, alpha: 0.90),
                     UIColor(red: 0.42, green: 0.78, blue: 0.40, alpha: 0.90),
                     UIColor(red: 0.56, green: 0.81, blue: 0.40, alpha: 0.90),
                     UIColor(red: 0.72, green: 0.84, blue: 0.40, alpha: 0.90),
                     UIColor(red: 0.87, green: 0.85, blue: 0.40, alpha: 0.90),
                     UIColor(red: 0.91, green: 0.73, blue: 0.41, alpha: 0.90),
                     UIColor(red: 0.94, green: 0.57, blue: 0.41, alpha: 0.90),
                     UIColor(red: 0.97, green: 0.41, blue: 0.42, alpha: 0.90)]

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
        barChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        pieChart.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        
        // Set centers of charts
        barChart.center = CGPoint(x: view.center.x, y: view.center.y + view.frame.size.height / 16)
        pieChart.center = CGPoint(x: view.center.x, y: view.center.y + view.frame.size.height / 16)
        
        view.addSubview(barChart)
        view.addSubview(pieChart)
        
        // Set values of grade data labels
        let gradeData = getGradeData(map: gpaMap)
        averageGradeLabel.text = "Average Grade = " + String(format: "%.3f", gradeData.average)
        medianGradeLabel.text = "Median Grade = " + String(gradeData.median)
        totalGradesLabel.text = String(gradeData.total) + " total grades"
        
        // Set chart specs
        self.setBarChart(values: self.gpaCounts)
        self.setPieChart(values: self.gpaCounts)
        
    }
    
    
    func setBarChart(values: [Int]) {
        
        let chartData = BarChartDataSet()
        chartData.colors = self.gpaColors
        
        for (i, val) in values.enumerated(){
            chartData.append(BarChartDataEntry(x: Double(i), y: Double(val)))
        }
        
        self.barChart.data = BarChartData(dataSet: chartData)
        self.barChart.data?.setValueTextColor(UIColor.white)
        
        self.barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: self.gpaArray)
        self.barChart.xAxis.labelTextColor = UIColor.white
        self.barChart.xAxis.labelPosition = .bottom
        
        self.barChart.leftAxis.labelTextColor = UIColor.white
        self.barChart.rightAxis.enabled = false
        
        self.barChart.isUserInteractionEnabled = false
        
        self.barChart.animate(yAxisDuration: 1.0)
        
        self.barChart.legend.enabled = false
    
    }
    
    
    func setPieChart(values: [Int]) {
        
        let chartData = PieChartDataSet()
        chartData.colors = self.gpaColors
        chartData.label = ""
        
        
        for (key, val) in self.gpaTuples {
            let entry = PieChartDataEntry(value: Double(val), label: key)
            
            chartData.append(entry)
        }
        
        self.pieChart.data = PieChartData(dataSet: chartData)
        
        self.pieChart.legend.textColor = UIColor.white
        
        self.pieChart.holeColor = self.view.backgroundColor
        
        self.pieChart.highlightPerTapEnabled = false
        self.pieChart.drawEntryLabelsEnabled = false
        
    }
    
    
    
    func getGradeData(map: [String: Int]) ->
        (average: Double, median: Double, total: Int) {
        
        // Get total
        let totalGrades = Array(map.values).reduce(0, +)
        
        var medianGrade = -1.0
        var averageGrade = 0.0
        
        // Get average
        for (key, value) in map {
            averageGrade += Double(key)! * Double(value)
        }
        
        averageGrade /= Double(totalGrades)
        
        // Get median
        var totalSeen = 0
        for gpa in self.gpaArray.reversed() {
            totalSeen += map[gpa]!
            
            if totalSeen > totalGrades / 2 {
                medianGrade = Double(gpa)!
                break
            }
        }
    
        return (average: averageGrade, median: medianGrade, total: totalGrades)
    }
    

    
    @IBAction func changeChart(_ sender: Any) {
        self.barChart.isHidden = !self.barChart.isHidden
        self.pieChart.isHidden = !self.pieChart.isHidden
    }
    

}
