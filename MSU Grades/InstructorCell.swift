//
//  InstructorCell.swift
//  MSU Grades
//
//  Created by Zach Arnold on 1/9/21.
//

import UIKit

class InstructorCell: UITableViewCell {

    @IBOutlet weak var instructorNameLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var medianLabel: UILabel!
    @IBOutlet weak var totalStudentsLabel: UILabel!
    @IBOutlet weak var latestDataLabel: UILabel!
    
    // Grade info to pass to chart view
    var gradeData = (average: -1.0, median: "", total: 0)
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
