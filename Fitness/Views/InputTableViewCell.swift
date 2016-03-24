//
//  InputTableViewCell.swift
//  Fitness
//
//  Created by Manuel Leitold on 26.06.15.
//  Copyright (c) 2015 - 2016 mani1337. All rights reserved.
//

import UIKit

@objc protocol InputTableViewCellDelegate {
    func inputTableViewCell(cell: InputTableViewCell, didChangedText newText: String)
}

class InputTableViewCell: UITableViewCell, UITextFieldDelegate {
    // MARK: - Vars
    var delegate: InputTableViewCellDelegate?
    var inputText: String = "" {
        didSet {
            self.textField.text = self.inputText
        }
    }
    
    // MARK: - Storyboard Outlets
    @IBOutlet weak var textField: UITextField!
    
    // MARK: - Storyboard Actions
    @IBAction func onTextFieldChanged(sender: AnyObject) {
        self.inputText = self.textField.text!
        self.delegate?.inputTableViewCell(self, didChangedText: self.inputText)
    }
    
    // MARK: - Overrided Base Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.textField.delegate = self
        self.textField.text = inputText
    }

    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
