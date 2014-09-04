//
//  DetailViewController.swift
//  ClassRoster
//
//  Created by Jacob Hawken on 8/13/14.
//  Copyright (c) 2014 Jacob Hawken. All rights reserved.

import UIKit
import QuartzCore
import Foundation

protocol DetailViewControllerDelegate {
    func saveChanges()
    func addStudent()
}

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
    var gitHubUserName: String?
    var delegate : DetailViewControllerDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.detailViewFirstName.delegate = self
        self.detailViewLastName.delegate = self
        
        //Adds border to
        self.gitHubUserNameLabel.layer.borderColor = UIColor.grayColor().CGColor
        self.gitHubUserNameLabel.layer.borderWidth = 0.5
        self.setupTextFieldNotificationObserver()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        if self.detailViewPerson.isNewPerson == true
        {
            self.detailViewPerson.profileImage = defaultGitHubImage
            self.detailViewPerson.idPicture = defaultImage
            do
            {
                self.studentId("Student ID Number", message: "Please enter student ID number.", alertStyle: UIAlertControllerStyle.Alert)
            } while self.detailViewPerson.idNumber == "000000"
        }
        
        if self.detailViewPerson.gitHubUserName == nil //if no username
        {
            self.detailViewGitHubUserImage.setImage(defaultGitHubImage, forState: UIControlState.Normal)
            self.gitHubUserNameLabel.text = "<-- click to add"
        }
        
        // Decides the main image.
        if detailViewPerson.idPicture != nil
        {
            self.detailViewPicture?.image = detailViewPerson.idPicture
            
            if self.detailViewPerson.gitHubUserName != nil //if no username
            {
                self.gitHubUserNameLabel.text = "  " + self.detailViewPerson.gitHubUserName!
                self.detailViewGitHubUserImage.setImage(self.detailViewPerson.profileImage, forState: UIControlState.Normal)
            }
        }
        else  //that is, if the the person doesn't hßave a stored image
        {
            self.detailViewPicture?.image = defaultImage
        }
        
        self.detailViewFirstName.text = self.detailViewPerson.firstName
        self.detailViewLastName.text = self.detailViewPerson.lastName
        self.detailViewStudentId.text = self.detailViewPerson.idNumber
        
        //rounds the image and puts a border around it
        imageProperties(self.detailViewPicture)
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
//        if self.detailViewPerson.gitHubUserName != nil
//        {
//            downloadFromGithub(self.detailViewPerson.gitHubUserName!)
//        }
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
        if self.detailViewPerson.isNewPerson == true
        {
            self.delegate?.addStudent(self.detailViewPerson)
        }
        self.detailViewPerson.isNewPerson = false
        self.delegate?.saveChanges()
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
        NSURLSession.sharedSession().dataTaskWithURL(gitHubUserUrl)
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
                
                self.detailViewPerson.gitHubUserName = gitHubUserName
                self.gitHubUserNameLabel.text = "  " + gitHubUserName
                
                if let avatarURL = jsonResult["avatar_url"] as? String
                {
                    profilePhotoURL = NSURL(string: avatarURL)
                } else
                {
                    self.activityIndicator.stopAnimating()
                    return
                }
                
                var profilePhotoData = NSData(contentsOfURL: profilePhotoURL)
                var profilePhotoImage = UIImage(data: profilePhotoData)
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.detailViewGitHubUserImage.setImage(profilePhotoImage, forState: UIControlState.Normal)
                    self.detailViewPerson.profileImage = profilePhotoImage as UIImage
                    self.detailViewPicture.image = profilePhotoImage as UIImage
                    self.detailViewPerson.idPicture = profilePhotoImage as UIImage
                    self.activityIndicator.stopAnimating()
                })
            }.resume()
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
            textField.placeholder = "GitHub Username"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (UIAlertAction) -> Void in
            self.activityIndicator.stopAnimating()
        }))
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            var textField = alert.textFields[0] as UITextField
            println(textField.text)
            self.gitHubUserNameLabel.text = "  " + textField.text
            self.downloadFromGithub(textField.text)
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func studentId(title: String, message: String, alertStyle: UIAlertControllerStyle)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
        
        alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "0000000"
        }
        
//        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (UIAlertAction) -> Void in
//            self.activityIndicator.stopAnimating()
//        }))
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            var textField = alert.textFields[0] as UITextField
            println(textField.text)
            self.detailViewStudentId.text = textField.text
            self.detailViewPerson.idNumber = textField.text
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func setupTextFieldNotificationObserver()
    {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        let mainQueue = NSOperationQueue.mainQueue()
        
        var observer = notificationCenter.addObserverForName(UITextFieldTextDidChangeNotification, object: nil, queue: mainQueue)
        { _ in
            self.detailViewPerson.firstName = self.detailViewFirstName.text
            self.detailViewPerson.lastName = self.detailViewLastName.text
            println(self.detailViewFirstName.text)
        }
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
