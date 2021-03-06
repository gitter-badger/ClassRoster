//
//  Person.swift
//  ClassRoster
//
//  Created by Jacob Hawken on 8/10/14.
//  Copyright (c) 2014 Jacob Hawken. All rights reserved.
//

import UIKit

class Person: NSObject, NSCoding
{
    var firstName: String?
    var lastName: String?
    var idNumber: String?
    var role: String?
    var idPicture: UIImage?
    var gitHubUserName: String?
    var profileImage: UIImage?
    var isNewPerson: Bool?
    
    init(firstName: String, lastName: String, idNumber: String, role: String)
    {
        self.firstName = firstName
        self.lastName = lastName
        self.idNumber = idNumber
        self.role = role
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        self.firstName = aDecoder.decodeObjectForKey("firstName") as? String
        self.lastName = aDecoder.decodeObjectForKey("lastName") as? String
        self.idNumber = aDecoder.decodeObjectForKey("idNumber") as? String
        self.role = aDecoder.decodeObjectForKey("role") as? String
        self.idPicture = aDecoder.decodeObjectForKey("idPicture") as? UIImage
        self.gitHubUserName = aDecoder.decodeObjectForKey("gitHubUserName") as? String
        self.profileImage = aDecoder.decodeObjectForKey("profileImage") as? UIImage
        self.isNewPerson = aDecoder.decodeObjectForKey("isNewPerson") as? Bool
    }
    
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(self.firstName!, forKey: "firstName")
        aCoder.encodeObject(self.lastName!, forKey: "lastName")
        aCoder.encodeObject(self.idNumber!, forKey: "idNumber")
        aCoder.encodeObject(self.role!, forKey: "role")
        if self.idPicture != nil {
            aCoder.encodeObject(self.idPicture!, forKey: "idPicture")
        }
        if self.gitHubUserName != nil {
            aCoder.encodeObject(self.gitHubUserName!, forKey: "gitHubUserName")

        }
        if self.profileImage != nil {
            aCoder.encodeObject(self.profileImage!, forKey: "profileImage")

        }
        if self.isNewPerson != nil {
            aCoder.encodeObject(self.isNewPerson!, forKey: "isNewPerson")

        }
    }
    
    func fullName() -> NSString
    {
        return self.firstName! + " " + self.lastName!
    }
}