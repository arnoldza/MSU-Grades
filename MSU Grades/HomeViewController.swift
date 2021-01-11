//
//  HomeViewController.swift
//  MSU Grades
//
//  Created by Zach Arnold on 12/21/20.
//

import UIKit

class HomeViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var classSearchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up search bar
        self.classSearchBar.delegate = self
        self.classSearchBar.backgroundImage = UIImage()
        
        self.navigationItem.titleView = self.classSearchBar
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.13, green: 0.36, blue: 0.31, alpha: 1.00)

        
        //Looks for single or multiple taps.
         let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
    
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.classSearchBar.endEditing(true)
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.classSearchBar.showsCancelButton = true
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSegue(withIdentifier: "courseSegue", sender: nil)
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.classSearchBar.text = ""
        self.classSearchBar.showsCancelButton = false
        self.classSearchBar.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // if segue is to course page
        if segue.identifier == "courseSegue" {
            
            // destination is course view controller
            let vc = segue.destination as! CourseViewController
            
            // tokenize components
            let components = self.classSearchBar.text!.components(separatedBy: " ")
            
            // pass the semesters to course view to put in table
            if let semesters = query(queryString: "SELECT * FROM courses WHERE subject_code == \"\(components[0])\" AND course_code == \"\(components[1])\";") {
                
                // filter out semesters and instructors from queried data
                let filteredSemesters = filterBySemester(classData: semesters)
                let filteredInstructors = filterByInstructor(classData: semesters)
                
                vc.semesters = filteredSemesters
                vc.instructors = filteredInstructors
                vc.courseName = components[0] + " " + components[1]
            }
        }
    }

}
