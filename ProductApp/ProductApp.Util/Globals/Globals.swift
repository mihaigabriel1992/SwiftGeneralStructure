//
//  Globals.swift
//  BookYourToilet
//
//  Created by Gabriel Petrescu on 12/21/15.
//  Copyright © 2015 OwnZones. All rights reserved.
//

import Foundation
import UIKit

func localizedString(forValue: String) -> String{
    return NSLocalizedString(forValue, comment: "")
}

func arrayFromContentsOfFileWithName(fileName: String) -> [String]? {
    guard let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "txt") else {
        return nil
    }
    
    do {
        let content = try String(contentsOfFile:path, encoding: NSUTF8StringEncoding)
        return content.componentsSeparatedByString("\n")
    } catch _ as NSError {
        return nil
    }
}

@objc class Globals: NSObject{
    
    static var APP_BRAND : String? = "frmt"
    static var key = 7;
    
    class func validateEmail(email: String) -> Bool {
        let emailRegex =
        "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        _ = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        
        return true;
    }
    
    class func dateToTimeAgo(date: String!) -> String{
        let dateFormatter : NSDateFormatter?
        var dateFromString : NSDate!
        let timeInterval : NSTimeInterval?
        
        dateFormatter = NSDateFormatter()
        dateFormatter?.dateFormat = "dd/MM/yyyy"
        dateFromString = NSDate()
        dateFromString = dateFormatter?.dateFromString(date)
        timeInterval = dateFromString.timeIntervalSinceNow
        var sec : Double
        sec = timeInterval!
        sec = sec * (-1)
        let days : Int
        days = Int(sec / 86400)
        
        if days < 1{
            return "today"
        }else if days == 1{
            return "yesterday"
        }
        
        return "\(days) d"
    }
    
}