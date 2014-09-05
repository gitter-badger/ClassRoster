//
//  ViewController.swift
//  ClassRoster
//
//  Created by Jacob Hawken on 8/9/14.
//  Copyright (c) 2014 Jacob Hawken. All rights reserved.

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DetailViewControllerDelegate
{
                            
    @IBOutlet weak var tableView: UITableView!
    
    var classRoster = [[Person](), [Person]()] as Array
    let plistPath = NSBundle.mainBundle().pathForResource("canvasClassRoster", ofType: "plist")
    let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
    var appendToRoster: shouldAddToRoster?
    var defaultPerson = Person(firstName: "First", lastName: "Last", idNumber: "000000", role: "student")
    
    //MARK: #Class Roster Management
    
    func initList(rosterArray: NSArray)
    {
        for name in rosterArray
        {
            var newPerson = Person(firstName: name["firstName"] as String, lastName: name["lastName"] as String, idNumber: name["id"] as String, role: name["role"] as String)
            newPerson.isNewPerson = false
            if newPerson.role == "student"
            {
                classRoster[0].append(newPerson)
            }
            if newPerson.role == "teacher"
            {
                classRoster[1].append(newPerson)
            }
        }
    }
    
    func addStudent(person: Person)
    {
        self.classRoster[0].append(person)
    }
    
    
    
    //MARK: #View Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if self.appendToRoster == nil
        {
            self.appendToRoster = shouldAddToRoster(person: defaultPerson)
        }
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool)
    {
        if self.appendToRoster?.readyToAdd == true
        {
            var newStudent = self.appendToRoster?.personArray[0]
            self.addStudent(newStudent!)
            self.appendToRoster?.empty()
            self.saveChanges()
        }
        self.loadPeopleFromDisk()
        self.tableView.reloadData()
    }
    
    //MARK: #Data Persistence
    
    func loadPeopleFromDisk() {
        if let people = NSKeyedUnarchiver.unarchiveObjectWithFile(documentsPath + "/archive") as? [[Person]]
        {
            self.classRoster = people
        }
        else
        {
            let nameList = NSArray(contentsOfFile: self.plistPath)
            self.initList(nameList)
        }

    }
    
    func saveRootObjectToDisk()
    {
        NSKeyedArchiver.archiveRootObject(self.classRoster, toFile: documentsPath + "/archive")
    }

    func saveChanges()
    {
        self.saveRootObjectToDisk()
    }
    
    //MARK: #tableView methods
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int
    {
        return self.classRoster[section].count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as CustomTableViewCell
        var personForRow = self.classRoster[indexPath.section][indexPath.row]

        cell.myLabel.text = personForRow.fullName()
        
        //image stuff
        if personForRow.idPicture != nil
        {
            cell.myImageView.image = personForRow.idPicture
        }
        else
        {
            cell.myImageView.image = UIImage(named:"silhouette.jpg")
        }
        
        cell.myImageView.layer.cornerRadius = cell.myImageView.frame.size.width / 2
        cell.myImageView.layer.masksToBounds = true
        cell.myImageView.layer.borderWidth = 0.5
        cell.myImageView.clipsToBounds = true
        cell.myImageView.contentMode = UIViewContentMode.ScaleAspectFill
        //cell.imageView.setNeedsDisplay()
        
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        println(indexPath.item)
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String
    {
        if (section == 0)
        {
            return "Students"
        }
        else
        {
            return "Teachers"
        }
    }
    
    //MARK: #Segue Stuff
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!)
    {
        if segue.identifier == "studentDetails"
        {
            var destination = segue.destinationViewController as DetailViewController
            //var selectedArray = self.classRoster[self.tableView.indexPathForSelectedRow().section]
            var selectedPerson = self.classRoster[self.tableView.indexPathForSelectedRow().section][self.tableView.indexPathForSelectedRow().row]
            
            destination.detailViewPerson = selectedPerson
            destination.delegate = self
        }
        if segue.identifier == "newPerson"
        {
            var destination = segue.destinationViewController as DetailViewController
            var selectedPerson: Person = Person(firstName: "First", lastName: "Last", idNumber: "000000", role: "student")
            selectedPerson.isNewPerson = true
            self.appendToRoster?.newPerson(selectedPerson)
            destination.detailViewPerson = selectedPerson
            destination.appendToRoster = appendToRoster
            destination.delegate = self
        }
    }
    
    //MARK: #Do we really need this thing?
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

class shouldAddToRoster: NSObject
{
    var readyToAdd: Bool?
    var personArray = [Person]() as Array
    
    init (person: Person)
    {
        personArray.append(person)
        self.readyToAdd = false
    }
    
    func newPerson (person: Person)
    {
        personArray.removeAll()
        personArray.append(person)
        self.readyToAdd = false
    }
    
    func empty()
    {
        personArray.removeAll()
        self.readyToAdd = false
    }
}