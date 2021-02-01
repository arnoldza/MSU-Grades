//
//  AboutViewController.swift
//  MSU Grades
//
//  Created by Zach Arnold on 1/31/21.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var infoLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Space to cushion labels from eachother / screen edges
        let labelCushion = view.frame.size.width / 30

        self.infoLabel.frame = CGRect(x: labelCushion, y: view.frame.size.height * 0.05, width: view.frame.size.width - labelCushion * 2, height: view.frame.size.height * 0.85)
        
        let title = "About MSU Grades\n"
        
        let italic = "\nThe long awaited iOS version of MSU Grades is finally here! Grade reports can be accessed offline and are broken down by course and instructor. Get started by searching for one on the home page!\n\nI welcome feedback, suggestions, issues, and general inqueries to zacharyarnold159@gmail.com, or via LinkedIn @ https://www.linkedin.com/in/zacharyarnoldmsu/\n\nMichigan State University and MSU are trademarks of Michigan State University. This app is not affiliated with or endorsed by Michigan State University.\n"
        
        let bold = "\nZach Arnold 2021 - Inspired by original web application by Collin Dillinger © 2017-2021 Grades LLC"
        
        let frameHeight = self.infoLabel.frame.height
        
        // Set up text attributes
        let attributedString = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: frameHeight * 0.055)])
        let infoAttributedString =  NSMutableAttributedString(string: italic, attributes: [NSAttributedString.Key.font : UIFont.italicSystemFont(ofSize: frameHeight * 0.025)])
        let boldAttributedString = NSMutableAttributedString(string: bold, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: frameHeight * 0.025)])

        attributedString.append(infoAttributedString)
        attributedString.append(boldAttributedString)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5

        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        self.infoLabel.adjustsFontSizeToFitWidth = true
        self.infoLabel.attributedText = attributedString
        self.infoLabel.lineBreakMode = .byTruncatingTail
        self.infoLabel.textColor = UIColor.white
        self.infoLabel.minimumScaleFactor = 0.5
        self.infoLabel.sizeToFit()
    }
   
}
