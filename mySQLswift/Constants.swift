//
//  Constants.swift
//  mySQLswift
//
//  Created by Peter Balsamo on 2/9/16.
//  Copyright © 2016 Peter Balsamo. All rights reserved.
//

import Foundation

    struct Config {
        static let NewsLead = "Customer News: Company to expand to a new web advertising directive this week."
        static let NewsCust = "Customer News: Check out or new line of fabulous windows and siding."
        static let NewsVend = "Business News: Peter Balsamo Appointed to United's Board of Directors."
        static let NewsEmploy = "Employee News: Health benifits cancelled immediately, ineffect starting today."
        static let BaseUrl = "http://lotpb.github.io/UnitedWebPage/index.html"
    }

    struct Color {
        static let BlueColor = UIColor(red:0.0, green:122.0/255.0, blue:1.0, alpha: 1.0)
        static let DGrayColor = UIColor(white:0.45, alpha:1.0)
        
        struct Blog {
            static let navColor = UIColor.redColor()
            static let borderbtnColor = UIColor.lightGrayColor().CGColor
            static let buttonColor = UIColor.redColor()
        }
        struct Lead {
            static let navColor = UIColor(red: 0.01, green: 0.48, blue: 1.0, alpha: 1.0)
            static let labelColor = DGrayColor
            static let labelColor1 = DGrayColor
        }
        
        struct Cust {
            static let navColor = UIColor(red: 0.21, green: 0.60, blue: 0.86, alpha: 1.0)
            static let labelColor = UIColor(red: 0.20, green: 0.29, blue: 0.37, alpha: 1.0)
            static let labelColor1 = UIColor(red: 0.20, green: 0.29, blue: 0.37, alpha: 1.0)
            static let buttonColor = BlueColor
        }
        
        struct Vend {
            static let navColor = UIColor(red: 0.56, green: 0.45, blue: 0.62, alpha: 1.0)
            static let labelColor = UIColor(red: 0.10, green: 0.03, blue: 0.21, alpha: 1.0)
        }
        
        struct News {
            static let navColor = DGrayColor
            static let buttonColor = BlueColor
        }
        
        struct Stat {
            static let navColor = UIColor.brownColor()
            //static let buttonColor = BlueColor
        }
        
        struct Table {
            static let navColor = UIColor(red: 0.28, green: 0.50, blue: 0.49, alpha: 1.0)
            static let labelColor = UIColor(red: 0.65, green: 0.49, blue: 0.35, alpha: 1.0)
        }
    }

    /*
    UIFontTextStyleTitle1 UIFontTextStyleTitle2 UIFontTextStyleTitle3
    UIFontTextStyleHeadline UIFontTextStyleSubheadline UIFontTextStyleBody
    UIFontTextStyleFootnote UIFontTextStyleCaption1 UIFontTextStyleCaption2
    */

    struct Font {
        static let navlabel = UIFont.systemFontOfSize(25, weight: UIFontWeightThin)
        static let headtitle = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        static let Edittitle = UIFont.systemFontOfSize(20, weight: UIFontWeightLight)
        //buttonFontSize,  labelFontSize, systemFontSize
        
        //static let celltitle = UIFont.systemFontOfSize(20, weight: UIFontWeightRegular)
        static let celltitle = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        static let cellsubtitle = UIFont.systemFontOfSize(17, weight: UIFontWeightRegular)
        static let celllabel1 = UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
        static let celllabel2 = UIFont.systemFontOfSize(17, weight: UIFontWeightMedium)
        static let cellreply = UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
        static let celllike = UIFont.systemFontOfSize(17, weight: UIFontWeightMedium)
        
        struct Blog {
            static let celltitle = UIFont.systemFontOfSize(18, weight: UIFontWeightBold)
            static let cellsubtitle = UIFont.systemFontOfSize(17, weight: UIFontWeightLight)
            static let celldate = UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
            static let cellLabel = UIFont.systemFontOfSize(17, weight: UIFontWeightBold)
            static let cellsubject = UIFont.systemFontOfSize(18, weight: UIFontWeightLight)
        }
        
        struct News {
            static let newstitle = UIFont.systemFontOfSize(20, weight: UIFontWeightMedium)
            static let newssource = UIFont.systemFontOfSize(16, weight: UIFontWeightLight)
            static let newslabel1 = UIFont.systemFontOfSize(16, weight: UIFontWeightBold)
            static let newslabel2 = UIFont.systemFontOfSize(12, weight: UIFontWeightLight)
        }
        
        struct Snapshot {
            static let celltitle = UIFont.systemFontOfSize(20, weight: UIFontWeightMedium)
        }
    }

