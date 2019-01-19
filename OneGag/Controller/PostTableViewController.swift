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
        
        if let savedPosts = Post.loadPosts() {
            posts = savedPosts.sorted(by: <)
        } else {
            posts = Post.loadSamplePosts()
        }
        
        navigationItem.leftBarButtonItem = editButtonItem

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let view = UIApplication.shared.keyWindow {
            view.addSubview(nasaButton)
            setupButton()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        nasaButton.removeFromSuperview()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as? PostCell else {fatalError("Could not deqeue cell")}
        let post = posts[indexPath.row]
        
        cell.nameLabel?.text = post.name
        cell.postImageView?.image = post.photo.image
        cell.setImageHeight()

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            posts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            Post.savePosts(posts)
        } else if editingStyle == .insert {}
    }
    
    @IBAction func unwindPostList(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else {return }
        let sourceViewController = segue.source as! PostViewController
        
        if let post = sourceViewController.post {
            if let selectedIndex = tableView.indexPathForSelectedRow {
                posts[selectedIndex.row] = post
            } else {
                let newIndexPath = IndexPath(row: posts.count, section: 0)
                posts.append(post)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            posts = posts.sorted(by: <)
            tableView.reloadSections(IndexSet(integer: 0), with: .none)
        }
        
        Post.savePosts(posts)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showPostDetails" {
            let postViewController = segue.destination as! PostViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedPost = posts[indexPath.row]
            postViewController.post = selectedPost
        }
        
        if segue.identifier == "nasaPost" {
            let postViewController = segue.destination as! PostViewController
            postViewController.nasa = true
        }
    }
    
    func fetchPhoto(completion: @escaping (PhotoInfo) -> Void) {
        let baseURL = URL(string: "https://api.nasa.gov/planetary/apod")!
        
        let query: [String: String] = [
            "api_key": "IS1zc4f1cFgDoNEgCSC6bwK6VrLcIPMzRvdQdhrL",
            ]
        
        let url = baseURL.withQueries(query)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data, let photoInfo = try? jsonDecoder.decode(PhotoInfo.self, from: data) {
                completion(photoInfo)
            }
        }
        
        task.resume()
    }
    
    lazy var nasaButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0, green: 0.8044245243, blue: 1, alpha: 1)
        button.setTitle("Create nasa post", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(nasaButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    func setupButton() {
        NSLayoutConstraint.activate([
            nasaButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 8),
            nasaButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 8),
            nasaButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            nasaButton.heightAnchor.constraint(equalToConstant: 60)
            ])
    }
    
    @objc func nasaButtonTapped(_ button: UIButton) {
        self.performSegue(withIdentifier: "nasaPost", sender: self)
    }
}

extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self,
                                       resolvingAgainstBaseURL: true)
        components?.queryItems = queries.map
            { URLQueryItem(name: $0.0, value: $0.1) }
        return components?.url
    }
    
    func withHTTPS() -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.scheme = "https"
        
        return components?.url
    }
}
