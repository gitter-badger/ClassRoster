//
//  DetailViewController.swift
//  ClassRoster
//
//  Created by Jacob Hawken on 8/13/14.
//  Copyright (c) 2014 Jacob Hawken. All rights reserved.
//

import UIKit
import QuartzCore

class DetailViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var detailViewFirstName: UITextField!
    @IBOutlet weak var detailViewLastName: UITextField!
    @IBOutlet weak var detailViewPicture: UIImageView!
    @IBOutlet weak var detailViewGitHubUserName: UITextField!
    @IBOutlet weak var detailViewStudentId: UILabel!
    
    var detailViewPerson = Person(firstName: "John", lastName: "Doe", idNumber: "12345", role: "student")
    var defaultImage: UIImage = UIImage(named:"silhouette.jpg")
    var madeChange: MadeChange?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.detailViewFirstName.delegate = self
        self.detailViewLastName.delegate = self
        self.detailViewFirstName.text = detailViewPerson.firstName
        self.detailViewLastName.text = detailViewPerson.lastName
        self.detailViewStudentId.text = detailViewPerson.idNumber
        imageProperties(self.detailViewPicture)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        if detailViewPerson.idPicture != nil
        {
            self.detailViewPicture?.image = detailViewPerson.idPicture
        }
        else
        {
            self.detailViewPicture?.image = defaultImage
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField!)
    {
        self.detailViewPerson.firstName = self.detailViewFirstName.text
        self.detailViewPerson.lastName = self.detailViewLastName.text
        self.detailViewPerson.gitHubUserName = self.detailViewGitHubUserName.text
        self.madeChange?.changesMade += 1
        println((self.madeChange?.changesMade))
    }
    
    @IBAction func photoButtonPressed(sender: UIButton)
    {
        var imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!)
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
        var editedImage = info[UIImagePickerControllerOriginalImage] as UIImage
        self.detailViewPicture?.image = editedImage
        detailViewPerson.idPicture = editedImage
        self.madeChange?.changesMade += 1
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!)
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imageProperties(view: UIView)
    {
        var layer = view.layer
        
        // Makes the image round
        self.detailViewPicture.clipsToBounds = true
        layer.cornerRadius = self.detailViewPicture.frame.size.width / 2
        
        // Applies border
        layer.borderColor = UIColor.grayColor().CGColor
        layer.borderWidth = 0.5
        
        // Is supposed to apply a shadow. Not sure why it doesn't.
//        layer.shadowColor = UIColor.blackColor().CGColor
//        layer.shadowOffset = CGSizeMake(0, 0)(width: 0, height: 0)
//        layer.shadowOpacity = 1.0
//        layer.shadowRadius = 3.0
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
