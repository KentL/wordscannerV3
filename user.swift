//
//  user.swift
//  Word Scanner
//
//  Created by XCode Developer (iOS/MacOS) on 2016-11-16.
//  Copyright © 2016 UPEICS. All rights reserved.
//

import Foundation
import CoreData

public class user
{
    private var username: String = ""
    private var password: String = ""
    private var email:String = ""
    
   
    public func setUsername(username:String)
    {
        self.username=username
    }
    public func setPassword(password:String)
    {
        self.password=password
    }
    public func setEmail(email:String)
    {
        self.email=email
    }
    public func getEmail ()->String
    {
        return self.email
    }
    public func getUsername ()->String
    {
        return self.username
    }
    
    public func getPassword()->String
    {
        return self.password
    }
    
    private func encryptPassword(password:String)
    {
        //encrypt Password here
    }
    
    private func decryptPassword(password:String)
    {
        //Decrypt password
    }
    
    
    
    
}