//
//  InstructorViewController.swift
//  MSU Grades
//
//  Created by Zach Arnold on 12/28/20.
//

import UIKit

class InstructorViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onDetailedInfoButton(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVc = storyboard.instantiateViewController(withIdentifier: "CombinedViewController") 
        var vcArray = self.navigationController?.viewControllers
        vcArray!.removeLast()
        vcArray!.append(newVc)
        self.navigationController?.setViewControllers(vcArray!, animated: true)
    }

}
