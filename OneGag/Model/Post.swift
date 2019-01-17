//
//  Post.swift
//  OneGag
//
//  Created by Pieter-Jan Clijsters on 17/01/2019.
//  Copyright © 2019 Pieter-Jan Clijsters. All rights reserved.
//

import UIKit

struct Post {
    var name: String
    var info: String
    var date: Date
    var image: UIImage
    
    init(name: String, info: String, image: UIImage, date: Date) {
        self.name = name
        self.info = info
        self.date = date
        self.image = image
    }
}
