//
//  JobViewCell.swift
//  mySQLswift
//
//  Created by Peter Balsamo on 12/17/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

import Foundation
import UIKit

class JobViewCell: UICollectionViewCell {
    
    //Snapshot Controller / UserView Controller
    @IBOutlet weak var user2ImageView: UIImageView?
    
    //Collection Controller / UserView Controller
    @IBOutlet weak var jobImageView: UIImageView?
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    

}


