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
        print("Searching...")
        performSegue(withIdentifier: "courseSegue", sender: nil)
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Cancelling...")
        self.classSearchBar.text = ""
        self.classSearchBar.showsCancelButton = false
        self.classSearchBar.endEditing(true)
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
