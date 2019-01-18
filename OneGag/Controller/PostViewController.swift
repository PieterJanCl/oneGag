//
//  PostViewController.swift
//  OneGag
//
//  Created by Pieter-Jan Clijsters on 18/01/2019.
//  Copyright © 2019 Pieter-Jan Clijsters. All rights reserved.
//

import UIKit

class PostViewController: UITableViewController, UITextViewDelegate {

    var isPickerHidden = true
    var post: Post?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var resultDate: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var extraInfoTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        extraInfoTextView.delegate = self
        
        if let post = post {
            navigationItem.title = "Post"
            nameTextField.text = post.name
            datePicker.date = post.date
            extraInfoTextView.text = post.info
        }
        
        if(extraInfoTextView.text.isEmpty) {
            extraInfoTextView.text = "Fill in extra information here"
            extraInfoTextView.textColor = UIColor.lightGray
        }
        
        updateSaveButtonState()
        updateResultDateLabel(date: datePicker.date)
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
        if extraInfoTextView.textColor == UIColor.lightGray {
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
        
        saveButton.isEnabled = !name.isEmpty && !extraInfo.isEmpty
    }
    
    func updateResultDateLabel(date: Date) {
        resultDate.text = Post.dateFormatter.string(from: date)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let normalCellHeight = CGFloat(44)
        let largeCellHeight = CGFloat(200)
        
        switch(indexPath) {
            case [1,0]: //Date cell
                return isPickerHidden ? normalCellHeight : largeCellHeight

            case [0,1]: //Extra info Cell
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
        
        post = Post(name: name, info: extraInfo, date: date)
    }
}

