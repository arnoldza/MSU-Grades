//
//  CombinedViewController.swift
//  MSU Grades
//
//  Created by Zach Arnold on 12/28/20.
//

import UIKit

class CombinedViewController: UIViewController {
    
    @IBAction func onCourseButton(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVc = storyboard.instantiateViewController(withIdentifier: "CourseViewController")
        var vcArray = self.navigationController?.viewControllers
        vcArray!.removeLast()
        vcArray!.append(newVc)
        self.navigationController?.setViewControllers(vcArray!, animated: true)
    }
    
    @IBAction func onInstructorButton(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVc = storyboard.instantiateViewController(withIdentifier: "InstructorViewController")
        var vcArray = self.navigationController?.viewControllers
        vcArray!.removeLast()
        vcArray!.append(newVc)
        self.navigationController?.setViewControllers(vcArray!, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
    }
    
    
    

}
