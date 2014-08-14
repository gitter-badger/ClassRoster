//
//  DetailViewController.swift
//  ClassRoster
//
//  Created by Jacob Hawken on 8/13/14.
//  Copyright (c) 2014 Jacob Hawken. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController
{

    @IBOutlet weak var studentName: UITextField!
    var person: Person?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.studentName.text = "First Name: \(person?.firstName)"
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
