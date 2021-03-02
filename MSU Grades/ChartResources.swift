//
//  ChartResources.swift
//  MSU Grades
//
//  Created by Zach Arnold on 1/10/21.
//

import Foundation
import UIKit

let smallLabelFontConstant = 0.046
let smallLabelFontName = "MuktaMahee Light"


// Ordering of elements in chart
let chartOrder = ["4.0", "3.5", "3.0", "2.5", "2.0", "1.5", "1.0", "0.0",
                    "A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D+",
                    "D", "D-", "F",
                    "Incomplete", "Withdrawn", "Pass", "Fail", "Deferred",
                    "Unfinished Work", "Visitor", "Auditor", "Extension",
                    "Conditional Pass", "No Grade Reported", "Blank"]

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
                 "Incomplete" : UIColor(red: 0.53, green: 0.33, blue: 0.55, alpha: 0.90),
                 "Withdrawn" : UIColor(red: 0.92, green: 0.22, blue: 0.17, alpha: 0.90),
                 "Pass" : UIColor(red: 0.48, green: 0.74, blue: 0.51, alpha: 0.90),
                 "Fail" : UIColor(red: 0.90, green: 0.45, blue: 0.44, alpha: 0.90),
                 "Deferred" : UIColor(red: 0.96, green: 0.71, blue: 0.45, alpha: 0.90),
                 "Unfinished Work" : UIColor(red: 0.52, green: 0.10, blue: 0.55, alpha: 0.90),
                 "Visitor" : UIColor(red: 0.03, green: 0.04, blue: 0.55, alpha: 0.90),
                 "Auditor" : UIColor(red: 0.25, green: 0.27, blue: 0.60, alpha: 0.90),
                 "Extension" : UIColor(red: 0.93, green: 0.41, blue: 0.17, alpha: 0.90),
                 "Conditional Pass" : UIColor(red: 0.95, green: 0.65, blue: 0.44, alpha: 0.90),
                 "No Grade Reported" : UIColor(red: 0.50, green: 0.50, blue: 0.50, alpha: 0.90),
                 "Blank" : UIColor(red: 0.59, green: 0.59, blue: 0.59, alpha: 0.90)]


// Create an attributed string for labels
// Top is larger italic text, bottom is smaller bold text
func createAttributedString(italic: String, bold: String, frameHeight: CGFloat) -> NSAttributedString {
    
    // Set up course title attributes
    let attributedString = NSMutableAttributedString(string: italic, attributes: [NSAttributedString.Key.font : UIFont.italicSystemFont(ofSize: frameHeight * 1/3)])
    let boldAttributedString = NSMutableAttributedString(string: bold, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: frameHeight * 1/4)])

    attributedString.append(boldAttributedString)
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 6

    attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
    
    return attributedString
}
