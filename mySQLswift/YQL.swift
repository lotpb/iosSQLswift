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
        
        if let jsonData = try? NSData(contentsOfURL: NSURL(string: query)!, options:NSDataReadingOptions.DataReadingMappedIfSafe) {
            
            if let jsonResult: AnyObject = try? NSJSONSerialization.JSONObjectWithData(jsonData, options:NSJSONReadingOptions.AllowFragments) {
                
                if let results = jsonResult as? NSDictionary {
                    //print("myDict:\(results)")
                    
                    let YQLtext:String = (((((results
                        .objectForKey("query") as! NSDictionary)
                        .objectForKey("results") as! NSDictionary)
                        .objectForKey("channel") as! NSDictionary)
                        .objectForKey("item") as! NSDictionary)
                        .objectForKey("condition") as! NSDictionary)
                        .objectForKey("text") as! String
                    let YQLtemp:String = (((((results
                        .objectForKey("query") as! NSDictionary)
                        .objectForKey("results") as! NSDictionary)
                        .objectForKey("channel") as! NSDictionary)
                        .objectForKey("item") as! NSDictionary)
                        .objectForKey("condition") as! NSDictionary)
                        .objectForKey("temp") as! String
                    print("Todays Weather: \(YQLtext) \(YQLtemp)")
                    
                    /*
                    let YQLprice:String = (((results
                        .objectForKey("query") as! NSDictionary)
                        .objectForKey("results") as! NSDictionary)
                        .objectForKey("quote") as! NSDictionary)
                        .objectForKey("LastTradePriceOnly") as! String
                    let YQLchange:String = (((results
                        .objectForKey("query") as! NSDictionary)
                        .objectForKey("results") as! NSDictionary)
                        .objectForKey("quote") as! NSDictionary)
                        .objectForKey("Change") as! String
                    print("Todays Stocks: \(YQLprice) \(YQLchange)")
                    */
                    
                }
            }
        } else {
            print("JSON Error")
        }
        return results
    }
}
