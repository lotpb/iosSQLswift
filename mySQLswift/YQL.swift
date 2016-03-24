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
                    
                    let YQLresults = results
                        .objectForKey("query")!
                        .objectForKey("results")!
                        .objectForKey("channel")!
                        .objectForKey("item")!
                        .objectForKey("condition")!
                    let YQLtext = YQLresults.objectForKey("text") as! String
                    let YQLtemp = YQLresults.objectForKey("temp")as! String
                    
                    print("Todays Weather: \(YQLtext) \(YQLtemp)")
                    /*
                    let YQLprice = results
                        .objectForKey("query")!
                        .objectForKey("results")!
                        .objectForKey("quote")!
                    let YQLlast = YQLprice.objectForKey("LastTradePriceOnly") as! String
                    let YQLchange = YQLprice.objectForKey("Change") as! String
                    
                    print("Todays stocks: \(YQLlast) \(YQLchange)") */
                    
                }
            }
        } else {
            print("JSON Error")
        }
        return results
    }
}
