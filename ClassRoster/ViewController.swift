//
//  ViewController.swift
//  ClassRoster
//
//  Created by Jacob Hawken on 8/9/14.
//  Copyright (c) 2014 Jacob Hawken. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
                            
    @IBOutlet weak var tableView: UITableView!
    
    var nameList = [["firstName":"Dave","lastName":"Fry"],["firstName":"Jake","lastName":"Hawken"]]
    var classRoster = [Person]()
    let plistPath = NSBundle.mainBundle().pathForResource("canvasClassRoster", ofType: "plist")
    
    func initList()
    {
        for name in nameList
        {
            var newPerson = Person(firstInput: name["firstName"]!, lastInput: name["lastName"]!)
            classRoster.append(newPerson)
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.initList()
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int
    {
        return self.classRoster.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        var personForRow = self.classRoster[indexPath.row]
        cell.textLabel.text = personForRow.fullName()
        
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        println(indexPath.item)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!)
    {
        if segue.identifier == "studentDetails"
        {
            var destination = segue.destinationViewController as DetailViewController
            var selectedPerson = self.classRoster[self.tableView.indexPathForSelectedRow().row]
            destination.person = selectedPerson
        }
    }
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

