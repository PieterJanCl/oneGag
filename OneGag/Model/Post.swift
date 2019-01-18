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
    var info: String?
    var date: Date
    
    init(name: String, info: String?, date: Date) {
        self.name = name
        self.info = info
        self.date = date
    }
    
    static func loadPost() -> [Post]? {
        return nil
    }
    
    static func loadSamplePosts() -> [Post] {
        let post1 = Post(name: "post1", info: "Dit is post 1", date: Date())
        let post2 = Post(name: "post2", info: "Dit is post 2", date: Date())
        let post3 = Post(name: "post3", info: "Dit is post 3", date: Date())
        
        return [post1, post2, post3]
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        return formatter
    }()
}
