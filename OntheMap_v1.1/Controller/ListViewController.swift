//
//  ListViewController.swift
//  OntheMap_v1.1
//
//  Created by Do Hyung Joo on 28/4/20.
//  Copyright © 2020 Do Hyung Joo. All rights reserved.
//

import UIKit
import Foundation

class ListViewController: UITableViewController {
    
    @IBOutlet var listView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listView.delegate = self
        listView.dataSource = self
        
        self.listView.reloadData()
        
        OnTheMapClient.getStudentLocation(completion: { (studentInformation, error) in
            
            var students = studentInformation
            
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return students.count
            }
            
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "listViewTableCell")!
                
                let student = students[indexPath.row]
                
                cell.textLabel?.text = student.firstName + student.lastName
                cell.detailTextLabel?.text = student.mediaURL
                cell.imageView?.image = UIImage(named: "icon_pin")
                
                return cell
            }
            
        })
    }
    
}
