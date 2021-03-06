//
//  CustomTableCell.swift
//  mySQLswift
//
//  Created by Peter Balsamo on 10/12/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//


import UIKit


class CustomTableCell: UITableViewCell {
    
    // Snapshot Controller
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var snaptitleLabel: UILabel!
    @IBOutlet weak var snapdetailLabel: UILabel!
    
    // Ad Controller
    @IBOutlet weak var adtitleLabel: UILabel!
    
    // Product Controller
    @IBOutlet weak var prodtitleLabel: UILabel!
    
    // Job Controller
    @IBOutlet weak var jobtitleLabel: UILabel!
    
    // salesman Controller
    @IBOutlet weak var salestitleLabel: UILabel!
    
    // BUser Controller
    @IBOutlet weak var usertitleLabel: UILabel!
    @IBOutlet weak var usersubtitleLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    // Lead Controller
    @IBOutlet weak var leadtitleLabel: UILabel!
    @IBOutlet weak var leadsubtitleLabel: UILabel!
    @IBOutlet weak var leadImageView: UIImageView!
    @IBOutlet weak var leadreplyButton: UIButton!
    @IBOutlet weak var leadlikeButton: UIButton!
    @IBOutlet weak var leadreplyLabel: UILabel!
    @IBOutlet weak var leadlikeLabel: UILabel!
    
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
    
    // Vendor Controller
    @IBOutlet weak var vendtitleLabel: UILabel!
    @IBOutlet weak var vendsubtitleLabel: UILabel!
    @IBOutlet weak var vendImageView: UIImageView!
    @IBOutlet weak var vendreplyButton: UIButton!
    @IBOutlet weak var vendlikeButton: UIButton!
    @IBOutlet weak var vendreplyLabel: UILabel!
    @IBOutlet weak var vendlikeLabel: UILabel!
    
    // Employee Controller
    @IBOutlet weak var employtitleLabel: UILabel!
    @IBOutlet weak var employsubtitleLabel: UILabel!
    @IBOutlet weak var employImageView: UIImageView!
    @IBOutlet weak var employreplyButton: UIButton!
    @IBOutlet weak var employlikeButton: UIButton!
    @IBOutlet weak var employreplyLabel: UILabel!
    @IBOutlet weak var employlikeLabel: UILabel!

    
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
    

}

