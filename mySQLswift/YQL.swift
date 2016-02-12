//
//  YQL.swift
//  YQLSwift
//
//  Created by Jake Lee on 1/25/15.
//  Copyright (c) 2015 JHL. All rights reserved.
//

import Foundation

struct YQL {
    
    private static let prefix:NSString = "http://query.yahooapis.com/v1/public/yql?&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=&q="
    
    static func query(statement:String) -> NSDictionary? {
        
        let escapedStatement = statement.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        let query = "\(prefix)\(escapedStatement!)"
        
        let results:NSDictionary? = nil
        
        let jsonData = try? NSData(contentsOfURL: NSURL(string: query)!, options:NSDataReadingOptions.DataReadingMappedIfSafe)
        
        if let jsonResult: AnyObject = try? NSJSONSerialization.JSONObjectWithData(jsonData!,options:NSJSONReadingOptions.AllowFragments) {
            
            if let results = jsonResult as? NSDictionary {
                print("myDict:\(results)")
            } /*
            else if let myArray = jsonResult as? NSArray {
                print("myArray:\(myArray)")
            } */
        }

        return results
    }
}
