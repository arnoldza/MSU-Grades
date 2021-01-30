//
//  SemesterCell.swift
//  MSU Grades
//
//  Created by Zach Arnold on 12/27/20.
//

import UIKit

// Font scale constant for data of cells
let dataFontConstant = 0.04

class SemesterCell: UITableViewCell {

    @IBOutlet weak var semesterLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var medianLabel: UILabel!
    @IBOutlet weak var totalStudentsLabel: UILabel!
    
    // Grade info to pass to chart view
    var gradeData = (average: -1.0, median: "", total: 0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


// Reusable function to setup contents of semester cell
func setupSemesterCell(cell: SemesterCell, semesters: [ClassInfo], row: Int, cellWidth: CGFloat) {
    
    if row % 2 == 0 {
        cell.backgroundColor = UIColor(white: 0.2, alpha: 1.0)
    } else {
        cell.backgroundColor = UIColor(white: 0.25, alpha: 1.0)
    }
    
    // Space to cushion labels from eachother / screen edges
    let labelCushion = cellWidth / 20
    
    // Height of cell
    let cellHeight = cellWidth * 0.3
    
    cell.semesterLabel.frame = CGRect(x: labelCushion, y: 0, width: cellWidth - labelCushion * 2, height: cellHeight / 2)
    
    cell.averageLabel.frame = CGRect(x: labelCushion, y: cellHeight * 1/2, width: cellWidth / 2 - labelCushion, height: cellHeight / 5)
    
    cell.medianLabel.frame = CGRect(x: labelCushion, y: cellHeight * 7/10, width: cellWidth / 2 - labelCushion, height: cellHeight / 5)
    
    cell.totalStudentsLabel.frame = CGRect(x: cellWidth / 2, y: cellHeight * 1/2, width: cellWidth / 2 - labelCushion, height: cellHeight / 5)
    
    cell.averageLabel.font = cell.averageLabel.font.withSize(cellWidth * CGFloat(dataFontConstant))
    cell.medianLabel.font = cell.medianLabel.font.withSize(cellWidth * CGFloat(dataFontConstant))
    cell.totalStudentsLabel.font = cell.totalStudentsLabel.font.withSize(cellWidth * CGFloat(dataFontConstant))
    cell.semesterLabel.font = cell.semesterLabel.font.withSize(cellWidth * 0.075)
    
    // get data to display on cell
    let semester = semesters[row]
    let data = getGradeData(gpaMap: semester.gradeInfo)
    let term = semester.term
    
    // edit attributes of cell to display or hold onto
    cell.semesterLabel.text = term
    
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
    cell.gradeData = data
}
