//
//  CustomTableCell.swift
//  mySQLswift
//
//  Created by Peter Balsamo on 10/12/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

import Foundation
import UIKit

import Parse

class CustomTableCell: UITableViewCell {
    
    // Snapshot Controller
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Ad Controller
    @IBOutlet weak var adtitleLabel: UILabel!
    
    // Product Controller
    @IBOutlet weak var prodtitleLabel: UILabel!
    
    // Job Controller
    @IBOutlet weak var jobtitleLabel: UILabel!
    
    // salesman Controller
    @IBOutlet weak var salestitleLabel: UILabel!
    
    // NewEditData Controller
    @IBOutlet weak var newedittitleLabel: UILabel!
    @IBOutlet weak var neweditsubtitleLabel: UILabel!
    @IBOutlet weak var neweditImageView: UIImageView!
    
    // BUser Controller
    @IBOutlet weak var usertitleLabel: UILabel!
    @IBOutlet weak var usersubtitleLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    // Lead Controller
    @IBOutlet weak var LeadtitleLabel: UILabel!
    @IBOutlet weak var LeadsubtitleLabel: UILabel!
    @IBOutlet weak var LeadImageView: UIImageView!
    
    // LeadDetailController
    @IBOutlet weak var leadtitleDetail: UILabel!
    @IBOutlet weak var leadsubtitleDetail: UILabel!
    @IBOutlet weak var leadreadDetail: UILabel!
    @IBOutlet weak var leadnewsDetail: UILabel!
    
    // Customer Controller
    @IBOutlet weak var custtitleLabel: UILabel!
    @IBOutlet weak var custsubtitleLabel: UILabel!
    @IBOutlet weak var custImageView: UIImageView!
    @IBOutlet weak var custreplyButton: UIButton!
    @IBOutlet weak var custlikeButton: UIButton!
    @IBOutlet weak var custreplyLabel: UILabel!
    @IBOutlet weak var custlikeLabel: UILabel!

    
    // BlogEditView
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var msgDateLabel: UILabel!
    @IBOutlet weak var blogImageView: UIImageView!
    
    @IBOutlet weak var replytitleLabel: UILabel!
    @IBOutlet weak var replysubtitleLabel: UILabel!
    @IBOutlet weak var replynumLabel: UILabel!
    @IBOutlet weak var replydateLabel: UILabel!
    @IBOutlet weak var replylikeButton: UIButton!
    @IBOutlet weak var replyImageView: UIImageView!
    
    // BlogController
    @IBOutlet weak var blogtitleLabel: UILabel!
    @IBOutlet weak var blogsubtitleLabel: UILabel!
    @IBOutlet weak var blogmsgDateLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var flagButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var actionBtn: UIButton!
    
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var blog2ImageView: UIImageView!
    
    var parseObject:PFObject? //  Copyright (c) 2015 AppCoda. example from Paws.
    
    
    override func awakeFromNib() {
        let gesture = UITapGestureRecognizer(target: self, action:Selector("onDoubleTap:"))
        gesture.numberOfTapsRequired = 2
        contentView.addGestureRecognizer(gesture)
        
        //catPawIcon?.hidden = true
        super.awakeFromNib()

    }
    
    func onDoubleTap(sender:AnyObject) {
        
        if(parseObject != nil) {
            if var likedNum:Int? = parseObject!.objectForKey("Liked") as? Int {
                likedNum!++
                
                parseObject!.setObject(likedNum!, forKey: "Liked");
                parseObject!.saveInBackground();
                
                
                numLabel?.text = "\(likedNum!) Liked";
            }
        }
        
        //catPawIcon?.hidden = false
        //catPawIcon?.alpha = 1.0
        
        UIView.animateWithDuration(1.0, delay: 1.0, options:[], animations: {
            
            //self.catPawIcon?.alpha = 0
            
            }, completion: {
                (value:Bool) in
                
                //self.catPawIcon?.hidden = true
        })
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}