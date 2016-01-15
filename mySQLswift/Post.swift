//
//  Post.swift
//  Coda
//
//  Created by Joyce Echessa on 1/12/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit

class Post: NSObject {
    
    var postTitle: String = ""
    var postURL: String = ""
    
    init(dictionary: Dictionary<String, String>) {
        self.postTitle = dictionary["postTitle"]!
        self.postURL = dictionary["postURL"]!
        super.init()
    }
   
}