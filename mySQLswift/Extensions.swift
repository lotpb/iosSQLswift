//
//  Constants.swift
//  mySQLswift
//
//  Created by Peter Balsamo on 2/9/16.
//  Copyright © 2016 Peter Balsamo. All rights reserved.
//

//import Foundation
import UIKit

    enum Config {
        static let NewsLead = "Customer News: Company to expand to a new web advertising directive this week."
        static let NewsCust = "Customer News: Check out or new line of fabulous windows and siding."
        static let NewsVend = "Business News: Peter Balsamo Appointed to United's Board of Directors."
        static let NewsEmploy = "Employee News: Health benifits cancelled immediately, ineffect starting today."
        static let BaseUrl = "http://lotpb.github.io/UnitedWebPage/index.html"
    }

    enum Color {
        static let BlueColor = UIColor(red:0.0, green:122.0/255.0, blue:1.0, alpha: 1.0)
        static let DGrayColor = UIColor(white:0.45, alpha:1.0)
        static let MGrayColor = UIColor(white:0.25, alpha:1.0)
        static let DGreenColor = UIColor(red:0.16, green:0.54, blue:0.13, alpha: 1.0)
        
        enum Blog {
            static let navColor = UIColor.redColor()
            static let borderbtnColor = UIColor.lightGrayColor().CGColor
            static let buttonColor = UIColor.redColor()
        }
        enum Lead {
            static let navColor = UIColor.blackColor() //UIColor(red: 0.01, green: 0.48, blue: 1.0, alpha: 1.0)
            static let labelColor = DGrayColor
            static let labelColor1 = UIColor.redColor() //DGrayColor
            static let buttonColor = UIColor.redColor()
        }
        
        enum Cust {
            static let navColor = UIColor.blackColor() //UIColor(red: 0.21, green: 0.60, blue: 0.86, alpha: 1.0)
            static let labelColor = DGrayColor //UIColor(red: 0.20, green: 0.29, blue: 0.37, alpha: 1.0)
            static let labelColor1 = BlueColor //UIColor(red: 0.20, green: 0.29, blue: 0.37, alpha: 1.0)
            static let buttonColor = BlueColor
        }
        
        enum Vend {
            static let navColor = UIColor.blackColor()
            static let labelColor = UIColor(red: 0.56, green: 0.45, blue: 0.62, alpha: 1.0)
            //static let labelColor1 = UIColor(red: 0.10, green: 0.03, blue: 0.21, alpha: 1.0)
            static let buttonColor = UIColor(red: 0.56, green: 0.45, blue: 0.62, alpha: 1.0)
        }
        
        enum Employ {
            static let navColor = UIColor.blackColor()
            static let labelColor = UIColor(red: 0.64, green: 0.54, blue: 0.50, alpha: 1.0)
            //static let labelColor1 = UIColor(red: 0.31, green: 0.23, blue: 0.17, alpha: 1.0)
            static let buttonColor = UIColor(red: 0.64, green: 0.54, blue: 0.50, alpha: 1.0)
        }
        
        enum News {
            static let navColor = UIColor.rgb(230, green: 32, blue: 31)
            static let buttonColor = BlueColor
        }
        
        enum Stat {
            static let navColor = UIColor.redColor()
            //static let buttonColor = BlueColor
        }
        
        enum Table {
            static let navColor = UIColor.blackColor()
            static let labelColor = UIColor(red: 0.28, green: 0.50, blue: 0.49, alpha: 1.0)
            //static let labelColor = UIColor(red: 0.65, green: 0.49, blue: 0.35, alpha: 1.0)
        }
    }

    /*
    UIFontTextStyleTitle1 UIFontTextStyleTitle2 UIFontTextStyleTitle3
    UIFontTextStyleHeadline UIFontTextStyleSubheadline UIFontTextStyleBody
    UIFontTextStyleFootnote UIFontTextStyleCaption1 UIFontTextStyleCaption2
    */

    struct Font {
        static let navlabel = UIFont.systemFontOfSize(25, weight: UIFontWeightMedium)
        static let headtitle = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        static let Edittitle = UIFont.systemFontOfSize(20, weight: UIFontWeightLight)
        static let Weathertitle = UIFont.systemFontOfSize(14, weight: UIFontWeightLight)
        //buttonFontSize,  labelFontSize, systemFontSize
        
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
            static let newstitle = UIFont.systemFontOfSize(18, weight: UIFontWeightRegular)
            static let newssource = UIFont.systemFontOfSize(16, weight: UIFontWeightLight)
            static let newslabel1 = UIFont.systemFontOfSize(16, weight: UIFontWeightBold)
            static let newslabel2 = UIFont.systemFontOfSize(14, weight: UIFontWeightLight)
        }
        
        struct Snapshot {
            static let celltitle = UIFont.systemFontOfSize(20, weight: UIFontWeightMedium)
        }
    }


// MARK: - RemoveWhiteSpace

public extension String {
    
    func removeWhiteSpace() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
}


// MARK: - AlertController

public extension UIViewController {
    
    func simpleAlert (title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}

//-----------youtube---------

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerate() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

let imageCache = NSCache()

class CustomImageView: UIImageView {
    
    var imageUrlString: String?
    
    func loadImageUsingUrlString(urlString: String) {
        
        imageUrlString = urlString
        
        let url = NSURL(string: urlString)
        
        image = nil
        
        if let imageFromCache = imageCache.objectForKey(urlString) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, respones, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                
                let imageToCache = UIImage(data: data!)
                
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
                
                imageCache.setObject(imageToCache!, forKey: urlString)
            })
            
        }).resume()
    }
    
}
 
//----------------------------

