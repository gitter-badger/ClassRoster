//
//  DetailViewController.swift
//  ClassRoster
//
//  Created by Jacob Hawken on 8/13/14.
//  Copyright (c) 2014 Jacob Hawken. All rights reserved.

import UIKit
import QuartzCore
import Foundation
import CoreData
import MobileCoreServices

class DetailViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var detailViewFirstName: UITextField!
    @IBOutlet weak var detailViewLastName: UITextField!
    @IBOutlet weak var detailViewPicture: UIImageView!
    @IBOutlet weak var detailViewStudentId: UILabel!
    @IBOutlet weak var gitHubUserNameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var detailViewGitHubUserImage: UIButton!
    
    var detailViewPerson = Person(firstName: "John", lastName: "Doe", idNumber: "12345", role: "student")
    var defaultImage: UIImage = UIImage(named:"silhouette.jpg")
    var defaultGitHubImage: UIImage = UIImage(named: "github_cat.png")
    var gitHubUserUrl: NSURL?
    var imageDownloadQueue = NSOperationQueue()
    var madeChange: MadeChange?
    var gitHubUserName: String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.detailViewFirstName.delegate = self
        self.detailViewLastName.delegate = self
    }
    
    override func viewWillAppear(animated: Bool)
    {
        // Decides the main image.
        if detailViewPerson.idPicture != nil
        {
            self.detailViewPicture?.image = detailViewPerson.idPicture
            
            if self.detailViewPerson.gitHubUserName == nil
            {
                self.detailViewGitHubUserImage.setImage(defaultGitHubImage, forState: UIControlState.Normal)
            }
            else
            {
                println(self.detailViewPerson.gitHubUserName)
            }
        }
        else  //that is, if the the person doesn't have a stored image
        {
            self.detailViewPicture?.image = defaultImage
        }
        
        self.detailViewFirstName.text = detailViewPerson.firstName
        self.detailViewLastName.text = detailViewPerson.lastName
        self.detailViewStudentId.text = detailViewPerson.idNumber
        self.gitHubUserNameLabel.text = detailViewPerson.gitHubUserName
        
        //rounds the image and puts a border around it
        imageProperties(self.detailViewPicture)
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        if self.detailViewPerson.gitHubUserName != nil
        {
            downloadFromGithub(self.gitHubUserNameLabel.text)
        }
    }
    
    
    //MARK: #Web API stuff
    
    func downloadFromGithub(gitHubUserName: String)
    {
        // Generates a URL based on the person's github username.
        gitHubUserUrl = NSURL(string: "https://api.github.com/users/\(gitHubUserName)")
        println(gitHubUserUrl)
        var profilePhotoURL = NSURL()
        let session = NSURLSession.sharedSession()
        self.activityIndicator.startAnimating()
        let task = NSURLSession.sharedSession().dataTaskWithURL(gitHubUserUrl)
            {(data, response, error) -> Void in
                
                var err: NSError?
                
                if error != nil
                {
                    println(error.localizedDescription)
                }
                
                var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
                
                if err != nil
                {
                    println("JSON Error \(err!.localizedDescription)")
                }
                
                if let avatarURL = jsonResult["avatar_url"] as? String
                {
                    profilePhotoURL = NSURL(string: avatarURL)
                }
                
                var profilePhotoData = NSData(contentsOfURL: profilePhotoURL)
                var profilePhotoImage = UIImage(data: profilePhotoData)
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    println("Main queue block run")
                    self.detailViewGitHubUserImage.setImage(profilePhotoImage, forState: UIControlState.Normal)
                    self.detailViewPerson.profileImage = profilePhotoImage as UIImage
                    self.detailViewPicture.image = profilePhotoImage as UIImage
                    self.detailViewPerson.idPicture = profilePhotoImage as UIImage
                    self.activityIndicator.stopAnimating()
                })
            }
        task.resume()
    }
    
    //MARK: #User Interaction Stuff
    
    @IBAction func gitHubButtonPressed(sender: AnyObject)
    {
        self.addAlertView("GitHub", message: "Enter your GitHub username.", alertStyle: UIAlertControllerStyle.Alert)
    }
    
    
    func addAlertView(title: String, message: String, alertStyle: UIAlertControllerStyle)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
        
        alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "GitHub Username:"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (UIAlertAction) -> Void in
            self.activityIndicator.stopAnimating()
        }))
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            var textField = alert.textFields[0] as UITextField
            println(textField.text)
            self.gitHubUserNameLabel.text = textField.text
            self.downloadFromGithub(textField.text)
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func textFieldDidEndEditing(textField: UITextField!)
    {
        self.detailViewPerson.firstName = self.detailViewFirstName.text
        self.detailViewPerson.lastName = self.detailViewLastName.text
        if self.detailViewPerson.gitHubUserName != self.gitHubUserNameLabel.text
        {
            self.detailViewPerson.gitHubUserName = self.gitHubUserNameLabel.text
            downloadFromGithub(self.gitHubUserNameLabel.text)
        }
        self.madeChange?.changesMade += 1
        println(self.madeChange?.changesMade)
    }
    
    //MARK: #Image and Camera Methods
    
    @IBAction func photoButtonPressed(sender: UIButton)
    {
        var imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func presentCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)
        {
            println("YES")
            var cameraUI = UIImagePickerController()
            cameraUI.delegate = self
            cameraUI.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            cameraUI.allowsEditing = true
            self.presentViewController(cameraUI, animated: true, completion: nil)
        }
        else
        {
            var alert = UIAlertView()
            alert.title = "No Device"
            alert.message = "Your device does not have the proper camera"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
        
        
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

    //MARK: #Do I even really need this thing?
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
