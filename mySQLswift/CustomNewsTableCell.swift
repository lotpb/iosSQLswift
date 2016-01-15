//
//  CatsTableViewCell.swift
//  Paws
//
//  Created by Simon Ng on 15/4/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import Foundation
import UIKit

class CustomNewsTableCell: UITableViewCell {
    
    @IBOutlet weak var newsImageView:UIImageView?
    @IBOutlet weak var newsNameLabel:UILabel?
    @IBOutlet weak var newsVotesLabel:UILabel?
    @IBOutlet weak var newsCreditLabel:UILabel?
    @IBOutlet weak var newsPawIcon:UIImageView?

    
    override func awakeFromNib() {
        
        let gesture = UITapGestureRecognizer(target: self, action:Selector("onDoubleTap:"))
        gesture.numberOfTapsRequired = 2
        contentView.addGestureRecognizer(gesture)
        
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
