//
//  Post.swift
//  OneGag
//
//  Created by Pieter-Jan Clijsters on 17/01/2019.
//  Copyright © 2019 Pieter-Jan Clijsters. All rights reserved.
//

import UIKit

struct Post: Codable {
    var name: String
    var info: String?
    var date: Date
    var photo: Data
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("posts").appendingPathExtension("plist")
    
    init(name: String, info: String?, date: Date, photo: UIImage) {
        self.name = name
        self.info = info
        self.date = date
        self.photo = photo.data!
    }
    
    static func loadPosts() -> [Post]? {
        guard let codedPosts = try? Data(contentsOf: ArchiveURL) else {return nil}
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<Post>.self, from: codedPosts)
    }
    
    static func savePosts(_ posts: [Post]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedPosts = try? propertyListEncoder.encode(posts)
        try? codedPosts?.write(to: ArchiveURL, options: .noFileProtection)
    }
    
    static func loadSamplePosts() -> [Post] {
        let post1 = Post(name: "post1", info: "Dit is post 1", date: Date(), photo: UIImage(named: "Swift")!)
        let post2 = Post(name: "post2", info: "Dit is post 2", date: Date(), photo: UIImage(named: "Swift")!)
        let post3 = Post(name: "post3", info: "Dit is post 3", date: Date(), photo: UIImage(named: "Swift")!)
        
        return [post1, post2, post3]
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        return formatter
    }()
}

extension UIImage {
    var data: Data? {
        if let data = self.jpegData(compressionQuality: 1.0) {
            return data
        } else {
            return nil
        }
    }
}

extension Data {
    var image: UIImage? {
        if let image = UIImage(data: self) {
            return image
        } else {
            return nil
        }
    }
}
