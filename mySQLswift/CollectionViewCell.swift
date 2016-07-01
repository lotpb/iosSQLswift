//
//  CCollectionViewCell.swift
//  mySQLswift
//
//  Created by Peter Balsamo on 12/17/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//


import UIKit

class CollectionViewCell: UICollectionViewCell {
  /*
//-----------youtube---------
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    } */
//---------------------------------


    // News
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var actionBtn: UIButton!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var uploadbyLabel: UILabel!
    
    // Snapshot Controller / UserView Controller
    @IBOutlet weak var user2ImageView: UIImageView?
    
    // Snapshot Controller / UserView Controller
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView?
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
    }
    
    //-----youtube action menu
    

    //-----------------------------------------------------

}


