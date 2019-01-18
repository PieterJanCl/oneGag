//
//  PostTableViewController.swift
//  OneGag
//
//  Created by Pieter-Jan Clijsters on 17/01/2019.
//  Copyright © 2019 Pieter-Jan Clijsters. All rights reserved.
//

import UIKit

class PostTableViewController: UITableViewController {

    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedPosts = Post.loadPost() {
            posts = savedPosts
        } else {
            posts = Post.loadSamplePosts()
        }
        
        navigationItem.leftBarButtonItem = editButtonItem
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") else {fatalError("Could not deqeue cell")}
        let post = posts[indexPath.row]
        
        cell.textLabel?.text = post.name
        

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            posts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {}
    }
    
    @IBAction func unwindPostList(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else {return }
        let sourceViewController = segue.source as! PostViewController
        
        if let post = sourceViewController.post {
            if let selectedIndex = tableView.indexPathForSelectedRow {
                posts[selectedIndex.row] = post
                tableView.reloadRows(at: [selectedIndex], with: .none)
            } else {
                let newIndexPath = IndexPath(row: posts.count, section: 0)
                 posts.append(post)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPostDetails" {
            let postViewController = segue.destination as! PostViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedPost = posts[indexPath.row]
            postViewController.post = selectedPost
        }
    }
}
