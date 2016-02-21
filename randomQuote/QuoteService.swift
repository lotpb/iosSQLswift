//
//  QuoteService.swift
//  TheLight
//
//  Created by Peter Balsamo on 2/19/16.
//  Copyright © 2016 Peter Balsamo. All rights reserved.
//

import Foundation

class QuoteService {

    var quotes = [
        "Chin up chap!",
        "God is Good",
        "Don't fight evil, Deny it battle.",
        "A smile a day...",
        "while I was still searching but not finding-- I found one upright man among a thousand, but not one upright woman among them all."
    ]
    func randomQuote() -> String {
        return quotes[ Int(arc4random_uniform(UInt32(quotes.count))) ]
    }

}