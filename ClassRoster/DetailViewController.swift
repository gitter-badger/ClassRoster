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
    @IBOutlet weak var detailViewFirstName: UITextField!
    @IBOutlet weak var detailViewLastName: UITextField!
    @IBOutlet weak var detailViewPicture: UIImageView!
    var detailViewPerson = Person(firstName: "John", lastName: "Doe", idNumber: "12345", role: "student")
    var defaultImage: UIImage = UIImage(named:"silhouette.jpg")
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.detailViewFirstName.delegate = self
        self.detailViewLastName.delegate = self
        self.detailViewFirstName.text = (detailViewPerson.firstName)
        self.detailViewLastName.text = (detailViewPerson.lastName)
        self.detailViewPicture.layer.cornerRadius = self.detailViewPicture.frame.size.width / 2;
        self.detailViewPicture.clipsToBounds = true
        applyPlainShadow(self.detailViewPicture)
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
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!)
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func applyPlainShadow(view: UIView)
    {
        var layer = view.layer
        
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 5
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
