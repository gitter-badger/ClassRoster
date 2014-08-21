//
//  DetailViewController.swift
//  ClassRoster
//
//  Created by Jacob Hawken on 8/13/14.
//  Copyright (c) 2014 Jacob Hawken. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var studentFirstName: UITextField!
    @IBOutlet weak var studentLastName: UITextField!
    @IBOutlet weak var studentPicture: UIImageView!
    var person = Person(firstName: "John", lastName: "Doe", idNumber: "12345", role: "student")
    var image: UIImage = UIImage(named:"silhouette.jpg")
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.studentFirstName.delegate = self
        self.studentLastName.delegate = self
        self.studentFirstName.text = (person.firstName)
        self.studentLastName.text = (person.lastName)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        if person.idPicture != nil
        {
            self.studentPicture?.image = person.idPicture
        }
        else
        {
            self.studentPicture?.image = image
        }
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
        self.studentPicture?.image = editedImage
        person.idPicture = editedImage  //I'm still not sure why adding this line fixed the display of the image from BEFORE I ever go to change the image
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!)
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
