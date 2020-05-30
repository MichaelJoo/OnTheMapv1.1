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
    @IBAction func Logout(_ sender: UIBarButtonItem) {
        
        OnTheMapClient.logout { (success, error) in
            DispatchQueue.main.async {
            if success {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let LoginView = storyBoard.instantiateViewController(withIdentifier: "LoginView") as! LoginViewController
            self.present(LoginView, animated: true, completion: nil)
            } else {
                let alertVC = UIAlertController(title: "Logout Error", message: "Logout Error", preferredStyle: .alert)
                self.present(alertVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    var students = [StudentDetails]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        
        listView.delegate = self
        listView.dataSource = self
    
        
        OnTheMapClient.getStudentLocation(completion: { (StudentInformation, error) in
            
            self.students = StudentInformation
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let student = students[indexPath.row]
        
        let url = URL(string: student.mediaURL)!
            
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }
    
    
}
