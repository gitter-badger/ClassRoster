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
    var idPicture: UIImage?
    
    init (firstInput:String, lastInput:String)
    {
        self.firstName = firstInput
        self.lastName = lastInput
    }
    
    func fullName() -> NSString
    {
        var fullName = self.firstName! + " " + self.lastName!
        return fullName
    }
}