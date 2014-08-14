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
    @IBOutlet weak var studentFirstName: UITextField!
    @IBOutlet weak var studentLastName: UITextField!
    @IBOutlet weak var studentPicture: UIImageView!
    var person = Person(firstInput: "John", lastInput: "Doe")
    var image: UIImage = UIImage(named:"silhouette.jpg")
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.studentFirstName.text = (person.firstName)
        self.studentLastName.text = (person.lastName)
        if person.idPicture != nil
        {
            self.studentPicture.image = person.idPicture
        }
        else
        {
            self.studentPicture.image = image
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
