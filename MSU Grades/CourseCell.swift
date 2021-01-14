//
//  CourseCell.swift
//  MSU Grades
//
//  Created by Zach Arnold on 1/13/21.
//

import UIKit

class CourseCell: UITableViewCell {
    
    @IBOutlet weak var courseTitleLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var medianLabel: UILabel!
    @IBOutlet weak var totalStudentsLabel: UILabel!
    @IBOutlet weak var latestDataLabel: UILabel!
    
    // Grade info to pass to chart view
    var gradeData = (average: -1.0, median: "", total: 0)

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
