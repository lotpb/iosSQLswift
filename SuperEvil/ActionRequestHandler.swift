//
//  ActionRequestHandler.swift
//  SuperEvil
//
//  Created by Peter Balsamo on 2/19/16.
//  Copyright © 2016 Peter Balsamo. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionRequestHandler: NSObject, NSExtensionRequestHandling {

    func beginRequestWithExtensionContext(context: NSExtensionContext) {
        let attachment = NSItemProvider(contentsOfURL: NSBundle.mainBundle().URLForResource("blockerList", withExtension: "json"))!
    
        let item = NSExtensionItem()
        item.attachments = [attachment]
    
        context.completeRequestReturningItems([item], completionHandler: nil)
    }
    
}
