//
//  PostViewController.swift
//  OneGag
//
//  Created by Pieter-Jan Clijsters on 18/01/2019.
//  Copyright © 2019 Pieter-Jan Clijsters. All rights reserved.
//

import UIKit

class PostViewController: UITableViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var isPickerHidden = true
    var post: Post?
    let postTableViewController = PostTableViewController()
    var nasa: Bool = false
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var resultDate: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var extraInfoTextView: UITextView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var choseImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        extraInfoTextView.delegate = self
        
        if let post = post {
            updateUI(post: post)
        }
        
        if(extraInfoTextView.text.isEmpty && !nasa) {
            extraInfoTextView.text = "Fill in extra information here"
            extraInfoTextView.textColor = UIColor.lightGray
        }
        
        updateSaveButtonState()
        updateResultDateLabel(date: datePicker.date)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PostViewController.imageTapped))
        postImageView.isUserInteractionEnabled = true
        postImageView.addGestureRecognizer(tapGestureRecognizer)
        
        if nasa == true {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            postTableViewController.fetchPhoto { (fetchinfo) in
                guard let url = fetchinfo.url.withHTTPS() else {return}
                
                let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.updateUI(post: Post(name: fetchinfo.title, info: fetchinfo.description, date: Date(), photo: image))
                            self.saveButton.isEnabled = true
                        }
                    }
                })
                
                task.resume()
                self.nasa = false
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        choseImage()
    }
    
    @IBAction func choseImage(_ sender: UIButton) {
        choseImage()
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        updateResultDateLabel(date: datePicker.date)
    }
    
    @IBAction func returnPressed(_ sender: UITextField) {
        nameTextField.resignFirstResponder()
        extraInfoTextView.resignFirstResponder()
    }
    
    // code found on stackoverflow to set placeholder in UITextView
    func textViewDidBeginEditing(_ extraInfoTextView: UITextView) {
        if extraInfoTextView.text == "Fill in extra information here" {
            extraInfoTextView.text = nil
            extraInfoTextView.textColor = UIColor.black
        }
    }
    // code found on stackoverflow to set placeholder in UITextView
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Fill in extra information here"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func updateSaveButtonState() {
        let name = nameTextField.text ?? ""
        let extraInfo = extraInfoTextView.text ?? ""
        let image = postImageView.image ?? UIImage(named: "code123098")
        
        saveButton.isEnabled = !name.isEmpty && !extraInfo.isEmpty && image != UIImage(named: "code123098")
    }
    
    func updateResultDateLabel(date: Date) {
        resultDate.text = Post.dateFormatter.string(from: date)
    }
    
    func choseImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertController = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style:
                .default, handler: {
                    action in imagePicker.sourceType = .camera
                    self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable (.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "photolibrary", style:
                .default, handler: {
                    action in imagePicker.sourceType = .photoLibrary
                    self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(photoLibraryAction)
        }
        
        alertController.popoverPresentationController?.sourceView = choseImageButton

        present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            postImageView.image = selectedImage
            choseImageButton.isHidden = true
            
            updateSaveButtonState()
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    func updateUI(post: Post) {
        navigationItem.title = "Post"
        nameTextField.text = post.name
        datePicker.date = post.date
        extraInfoTextView.text = post.info
        postImageView.image = post.photo.image
        choseImageButton.isHidden = true
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let normalCellHeight = CGFloat(44)
        let largeCellHeight = CGFloat(200)
        
        switch(indexPath) {
            case [1,0]: //Date cell
                return isPickerHidden ? normalCellHeight : largeCellHeight

            case [0,1]: //Extra info Cell
                return largeCellHeight
            
            case [2,0]: //ImageView
                return largeCellHeight

            default: return normalCellHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath) {
            case [1,0]:
                isPickerHidden = !isPickerHidden
                
                resultDate.textColor = isPickerHidden ? .black : tableView.tintColor

                tableView.beginUpdates()
                tableView.endUpdates()

            default: break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else {return}
        
        let name = nameTextField.text!
        let extraInfo = extraInfoTextView.text!
        let date = datePicker.date
        let image: UIImage = postImageView.image!
        
        post = Post(name: name, info: extraInfo, date: date, photo: image)
    }
}

