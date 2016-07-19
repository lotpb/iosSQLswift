//
//  User.swift
//  gameofchats
//
//  Created by Brian Voong on 6/29/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var bcryptPassword: String?
    var createdAt: String?
    var email: String?
    var emailVerified: Bool?
    var objectId: String?
    var phone: String?
    var currentLocation: String?
    var imageFile: String?
    var profileImageUrl: String?
    var updatedAt: String?
    var username: String?
}
