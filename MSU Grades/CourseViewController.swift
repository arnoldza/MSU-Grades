//
//  SectionsViewController.swift
//  MSU Grades
//
//  Created by Zach Arnold on 12/27/20.
//

import UIKit

class CourseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.backgroundColor = view.backgroundColor
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SectionCell()
        cell.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "chartSegue", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
