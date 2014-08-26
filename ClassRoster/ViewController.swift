//
//  ViewController.swift
//  ClassRoster
//
//  Created by Jacob Hawken on 8/9/14.
//  Copyright (c) 2014 Jacob Hawken. All rights reserved.

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
                            
    @IBOutlet weak var tableView: UITableView!
    
    var classRoster = [[Person](), [Person]()] as Array
    let plistPath = NSBundle.mainBundle().pathForResource("canvasClassRoster", ofType: "plist")
    let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
    var madeChange: MadeChange = MadeChange()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
//        self.loadPeopleFromDisk()
    }
    
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
    
    override func viewWillAppear(animated: Bool)
    {
        if self.madeChange.changesMade > 0
        {
            self.saveRootObjectToDisk()
            self.madeChange.changesMade = 0
        }
        self.loadPeopleFromDisk()
        self.tableView.reloadData()
    }
    
    func saveRootObjectToDisk() {
        NSKeyedArchiver.archiveRootObject(self.classRoster, toFile: documentsPath + "/archive")
    }
    
    func initList(rosterArray: NSArray)
    {
        for name in rosterArray
        {
            var newPerson = Person(firstName: name["firstName"] as String, lastName: name["lastName"] as String, idNumber: name["id"] as String, role: name["role"] as String)
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

    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int
    {
        return self.classRoster[section].count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        var personForRow = self.classRoster[indexPath.section][indexPath.row]
        cell.textLabel.text = personForRow.fullName()
        
        //image stuff
        if personForRow.idPicture != nil
        {
            cell.imageView.image = personForRow.idPicture
        }
        else
        {
            cell.imageView.image = UIImage(named:"silhouette.jpg")
        }
        
        cell.imageView.clipsToBounds = true
        cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width
        
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        println(indexPath.item)
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return classRoster.count
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
    
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!)
    {
        if segue.identifier == "studentDetails"
        {
            var destination = segue.destinationViewController as DetailViewController
            var selectedArray = self.classRoster[self.tableView.indexPathForSelectedRow().section]
            var selectedPerson = selectedArray[self.tableView.indexPathForSelectedRow().row]
            destination.detailViewPerson = selectedPerson
            destination.madeChange = self.madeChange
        }
    }
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

