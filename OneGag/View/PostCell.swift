//
//  PostCell.swift
//  OneGag
//
//  Created by Pieter-Jan Clijsters on 18/01/2019.
//  Copyright © 2019 Pieter-Jan Clijsters. All rights reserved.
//

import UIKit
import MessageUI

class PostCell : UITableViewCell, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postImageViewHeight: NSLayoutConstraint!
    
    func setImageHeight() {
        if postImageView.frame.size.width < (postImageView.image?.size.width)! {
            postImageViewHeight.constant = postImageView.frame.size.width / (postImageView.image?.size.width)! * (postImageView.image?.size.height)!
        }
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        guard let image = postImageView.image else {return}
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        activityController.popoverPresentationController?.sourceView = sender
        
        UIApplication.shared.keyWindow?.rootViewController?.present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func sendEmail(_ sender: UIButton) {
        guard MFMailComposeViewController.canSendMail() else {
            print("cant send mail right now")
            return
        }
        
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setSubject(nameLabel.text ?? "Look what I saw")
        mailComposer.addAttachmentData(postImageView.image!.data!, mimeType: "photo", fileName: nameLabel.text ?? "")
        
        UIApplication.shared.keyWindow?.rootViewController?.present(mailComposer, animated: true)
    }
    
    
}
