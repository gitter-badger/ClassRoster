//
//  ViewController.swift
//  ClassRoster
//
//  Created by Jacob Hawken on 8/9/14.
//  Copyright (c) 2014 Jacob Hawken. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.initList()
    }
    
    var nameList = [["firstName":"Dave","lastName":"Fry"],["firstName":"Jake","lastName":"Hawken"]]
    
    var classRoster = [Person]()
    
    func initList()
    {
        for name in nameList
        {
            var newPerson = Person(firstInput: name["firstName"]!, lastInput: name["lastName"]!)
            classRoster.append(newPerson)
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

