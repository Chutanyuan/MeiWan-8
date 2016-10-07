//
//  PersistenceManager.swift
//  MeiWan
//
//  Created by mac on 15/8/28.
//  Copyright (c) 2015年 apple. All rights reserved.
//

import UIKit

@objc public class PersistenceManager: NSObject {
    public static func setLoginUser(userDict:NSDictionary){
        NSUserDefaults.standardUserDefaults().setObject(userDict, forKey: "loginUser");
    }
    public static func getLoginUser()->NSDictionary?{
        return NSUserDefaults.standardUserDefaults().objectForKey("loginUser")as? NSDictionary;
    }
    
    public static func setLoginSession(session:String){
        NSUserDefaults.standardUserDefaults().setObject(session, forKey: "loginSession");
    }
    public static func getLoginSession()->String?{
        return NSUserDefaults.standardUserDefaults().objectForKey("loginSession")as? String;
    }
}
