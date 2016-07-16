//
//  CCollectionViewCell.swift
//  mySQLswift
//
//  Created by Peter Balsamo on 12/17/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

import UIKit
import Parse

class CollectionViewCell: UICollectionViewCell {
    
    //-----------youtube---------
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    //---------------------------------
    
    // News
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var profileView: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var sourceLabel: UILabel?
    @IBOutlet weak var likeButton: UIButton?
    @IBOutlet weak var actionBtn: UIButton?
    @IBOutlet weak var numLabel: UILabel?
    @IBOutlet weak var uploadbyLabel: UILabel?
    
    // Snapshot Controller / UserView Controller
    @IBOutlet weak var user2ImageView: UIImageView?
    
    // Snapshot Controller / UserView Controller
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
    }
    
}

class VideoCell: CollectionViewCell {
    
    var video: Video? {
        didSet {
            

        }
    }
 
    let thumbnailImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.userInteractionEnabled = true
        imageView.backgroundColor = UIColor.blackColor()
        imageView.image = UIImage(named: "taylor_swift_blank_space")
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let userProfileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.image = UIImage(named: "taylor_swift_profile")
        imageView.layer.cornerRadius = 22
        imageView.layer.masksToBounds = true
        imageView.contentMode = .ScaleAspectFill
        
        //cell.profileView?.layer.cornerRadius = (cell.profileView?.frame.size.width)! / 2
        imageView.layer.borderColor = UIColor.lightGrayColor().CGColor
        imageView.layer.borderWidth = 0.5
        imageView.userInteractionEnabled = true
        //cell.profileView?.tag = indexPath.row
        return imageView
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        return view
    }()
    
    let titleLabelnew: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Taylor Swift - Blank Space"
        label.numberOfLines = 2
        return label
    }()
    
    let subtitlelabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "TaylorSwiftVEVO • 1,604,684,607 views • 2 years ago"
        label.textColor = UIColor.lightGrayColor()
        return label
    }()
    
    let actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.lightGrayColor()
        let imagebutton : UIImage? = UIImage(named:"nav_more_icon.png")!.imageWithRenderingMode(.AlwaysTemplate)
        button.setImage(imagebutton, forState: .Normal)
        return button
    }()
    
    let likeButt: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.lightGrayColor()
        let imagebutton : UIImage? = UIImage(named:"Thumb Up.png")!.imageWithRenderingMode(.AlwaysTemplate)
        button.setImage(imagebutton, forState: .Normal)
        return button
    }()
    
    let numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "10"
        label.textColor = UIColor.blueColor()
        return label
    }()
    
    let uploadbylabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Uploaded by:"
        return label
    }()

    var titleLabelHeightConstraint: NSLayoutConstraint?
    
    override func setupViews() {
        addSubview(thumbnailImageView)
        addSubview(separatorView)
        addSubview(userProfileImageView)
        addSubview(titleLabelnew)
        addSubview(subtitlelabel)
        addSubview(actionButton)
        addSubview(likeButt)
        addSubview(numberLabel)
        addSubview(uploadbylabel)
        
        addConstraintsWithFormat("H:|-16-[v0]-16-|", views: thumbnailImageView)
        
        addConstraintsWithFormat("H:|-16-[v0(44)]", views: userProfileImageView)
        
        addConstraintsWithFormat("H:|-16-[v0(25)]", views: actionButton)
        
        //vertical constraints
        addConstraintsWithFormat("V:|-16-[v0]-8-[v1(44)]-21-[v2(25)]-10-[v3(1)]|", views: thumbnailImageView, userProfileImageView, actionButton, separatorView)
        
        addConstraintsWithFormat("H:|[v0]|", views: separatorView)
        
        //top constraint
        addConstraint(NSLayoutConstraint(item: titleLabelnew, attribute: .Top, relatedBy: .Equal, toItem: thumbnailImageView, attribute: .Bottom, multiplier: 1, constant: 6))
        //left constraint
        addConstraint(NSLayoutConstraint(item: titleLabelnew, attribute: .Left, relatedBy: .Equal, toItem: userProfileImageView, attribute: .Right, multiplier: 1, constant: 8))
        //right constraint
        addConstraint(NSLayoutConstraint(item: titleLabelnew, attribute: .Right, relatedBy: .Equal, toItem: thumbnailImageView, attribute: .Right, multiplier: 1, constant: 0))
        
        //height constraint
        titleLabelHeightConstraint = NSLayoutConstraint(item: titleLabelnew, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 0, constant: 44)
        addConstraint(titleLabelHeightConstraint!)

        //top constraint
        addConstraint(NSLayoutConstraint(item: subtitlelabel, attribute: .Top, relatedBy: .Equal, toItem: titleLabelnew, attribute: .Bottom, multiplier: 1, constant: 1))
        //left constraint
        addConstraint(NSLayoutConstraint(item: subtitlelabel, attribute: .Left, relatedBy: .Equal, toItem: userProfileImageView, attribute: .Right, multiplier: 1, constant: 8))
        //right constraint
        addConstraint(NSLayoutConstraint(item: subtitlelabel, attribute: .Right, relatedBy: .Equal, toItem: thumbnailImageView, attribute: .Right, multiplier: 1, constant: 0))
        //height constraint
        addConstraint(NSLayoutConstraint(item: subtitlelabel, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 0, constant: 21))
        
        //top constraint
        addConstraint(NSLayoutConstraint(item: likeButt, attribute: .Top, relatedBy: .Equal, toItem: subtitlelabel, attribute: .Bottom, multiplier: 1, constant: 1))
        //left constraint
        addConstraint(NSLayoutConstraint(item: likeButt, attribute: .Left, relatedBy: .Equal, toItem: actionButton, attribute: .Right, multiplier: 1, constant: 12))
        //right constraint
        //addConstraint(NSLayoutConstraint(item: likeButt, attribute: .Right, relatedBy: .Equal, toItem: thumbnailImageView, attribute: .Right, multiplier: 1, constant: 0))
        //height constraint
        addConstraint(NSLayoutConstraint(item: likeButt, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 0, constant: 25))
        
        //top constraint
        addConstraint(NSLayoutConstraint(item: numberLabel, attribute: .Top, relatedBy: .Equal, toItem: subtitlelabel, attribute: .Bottom, multiplier: 1, constant: 1))
        //left constraint
        addConstraint(NSLayoutConstraint(item: numberLabel, attribute: .Left, relatedBy: .Equal, toItem: likeButt, attribute: .Right, multiplier: 1, constant: 1))
        //right constraint
        //addConstraint(NSLayoutConstraint(item: numberLabel, attribute: .Right, relatedBy: .Equal, toItem: thumbnailImageView, attribute: .Right, multiplier: 1, constant: 0))
        //height constraint
        addConstraint(NSLayoutConstraint(item: numberLabel, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 0, constant: 25))
        
        //top constraint
        addConstraint(NSLayoutConstraint(item: uploadbylabel, attribute: .Top, relatedBy: .Equal, toItem: subtitlelabel, attribute: .Bottom, multiplier: 1, constant: 1))
        //left constraint
        addConstraint(NSLayoutConstraint(item: uploadbylabel, attribute: .Left, relatedBy: .Equal, toItem: numberLabel, attribute: .Right, multiplier: 1, constant: 5))
        //right constraint
        //addConstraint(NSLayoutConstraint(item: uploadbylabel, attribute: .Right, relatedBy: .Equal, toItem: thumbnailImageView, attribute: .Right, multiplier: 1, constant: 0))
        //height constraint
        addConstraint(NSLayoutConstraint(item: uploadbylabel, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 0, constant: 25))
    }
}

