//
//  NSArrayHelpers.swift
//  Marcel Voss
//
//  Created by Marcel Voß on 15.04.15.
//  Copyright (c) 2015 Marcel Voß. All rights reserved.
//

import UIKit

class NSArrayUtilities: NSObject {
    
    class func arrayForJSON(filename: String) -> NSArray? {
        
        let file  = NSBundle.mainBundle().pathForResource(filename, ofType:"json")
        let data = NSData(contentsOfFile:file!)
        
        do {
            let sJson = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
            return sJson as? NSArray;
            //let anyObj = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! [String:AnyObject]
            // use anyObj here
        } catch {
            print("json error: \(error)")
        }
        
        
        //let sJson = NSJSONSerialization.JSONObjectWithData(data!, options:nil, error: ) as! NSArray
        
        return nil;
        
    }
    
    class func randomObject(array: Array<AnyObject>) -> AnyObject {
        
        let index = Int(arc4random_uniform(UInt32(array.count)))
        let theObject: AnyObject = array[index]
        
        return theObject
    }

}