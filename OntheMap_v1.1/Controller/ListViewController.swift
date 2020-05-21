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
    
    var students = [studentDetails]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listView.delegate = self
        listView.dataSource = self
    
        
        OnTheMapClient.getStudentLocation(completion: { (studentInformation, error) in
            
            self.students = studentInformation
            self.listView.reloadData()
        })
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "listViewTableCell")!
        
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "listViewTableCell")
        
        let student = students[indexPath.row]
        
        cell.textLabel?.text = student.firstName + student.lastName
        cell.detailTextLabel?.text = student.mediaURL
        cell.imageView?.image = UIImage(named: "icon_pin")
        
        return cell
    }
    
}
