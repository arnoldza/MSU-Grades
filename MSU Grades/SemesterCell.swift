//
//  SemesterCell.swift
//  MSU Grades
//
//  Created by Zach Arnold on 12/27/20.
//

import UIKit

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
