//
//  Person.swift
//  ClassRoster
//
//  Created by Jacob Hawken on 8/10/14.
//  Copyright (c) 2014 Jacob Hawken. All rights reserved.
//

import UIKit

class Person: NSObject
{
    var firstName: String?
    var lastName: String?
    var idNumber: String?
    var role: String?
    var idPicture: UIImage?
    
    init(firstName: String, lastName: String, idNumber: String)
    {
        self.firstName = firstName
        self.lastName = lastName
        self.idNumber = idNumber
    }
    
    func fullName() -> NSString
    {
        return self.firstName! + " " + self.lastName!
    }
}