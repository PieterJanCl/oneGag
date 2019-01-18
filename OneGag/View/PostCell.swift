//
//  PostCell.swift
//  OneGag
//
//  Created by Pieter-Jan Clijsters on 18/01/2019.
//  Copyright © 2019 Pieter-Jan Clijsters. All rights reserved.
//

import UIKit

class PostCell : UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postImageViewHeight: NSLayoutConstraint!
    
    func setImageHeight() {
        if postImageView.frame.size.width < (postImageView.image?.size.width)! {
            postImageViewHeight.constant = postImageView.frame.size.width / (postImageView.image?.size.width)! * (postImageView.image?.size.height)!
        }
    }
}
