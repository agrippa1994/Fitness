//
//  EditExerciseTableViewController.swift
//  Fitness
//
//  Created by Manuel Stampfl on 25.06.15.
//  Copyright (c) 2015 mani1337. All rights reserved.
//

import UIKit

@objc protocol EditExerciseTableViewControllerDelegate {
    func editExerciseTableViewControllerDidCancelled(controller: EditExerciseTableViewController)
    func editExerciseTableViewControllerDidFinished(controller: EditExerciseTableViewController)
}

class EditExerciseTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    // MARK: - Vars
    weak var delegate: EditExerciseTableViewControllerDelegate?
    var exercise:Exercise?
    
    // MARK: - Storyboard Outlets
    @IBOutlet weak var typePickerView: UIPickerView!
    @IBOutlet weak var warmupPickerView: UIPickerView!
    @IBOutlet weak var durationTimerView: UIPickerView!
    
    // MARK: - Storyboard Actions
    @IBAction func onBarButtonItemSave(sender: AnyObject) {
        if self.exercise == nil {
            self.exercise = Exercise()
        }
        
        self.exercise!.type = ExerciseType(rawValue: self.typePickerView.selectedRowInComponent(0))!
        self.exercise!.warmup = NSTimeInterval(self.warmupPickerView.selectedRowInComponent(0) + 5)
        self.exercise!.duration = NSTimeInterval(self.durationTimerView.selectedRowInComponent(0) + 1)
        
        self.delegate?.editExerciseTableViewControllerDidFinished(self)
    }
    
    @IBAction func onBarButtonItemClose(sender: AnyObject) {
        delegate?.editExerciseTableViewControllerDidCancelled(self)
    }
    
    // MARK: - Overrided Base Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.typePickerView.delegate = self
        self.typePickerView.dataSource = self
        
        self.warmupPickerView.delegate = self
        self.warmupPickerView.dataSource = self
        
        self.durationTimerView.delegate = self
        self.durationTimerView.dataSource = self
        
        var type: ExerciseType = .Running
        var warmup: NSTimeInterval = 5.0
        var duration: NSTimeInterval = 60.0
        if self.exercise != nil {
            type = self.exercise!.type
            warmup = self.exercise!.warmup
            duration = self.exercise!.duration
        }
        
        self.typePickerView.selectRow(type.rawValue, inComponent: 0, animated: false)
        self.warmupPickerView.selectRow(Int(warmup) - 5, inComponent: 0, animated: false)
        self.durationTimerView.selectRow(Int(duration) - 1, inComponent: 0, animated: false)
    }
    

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case self.typePickerView:
            return ExerciseType.Count.rawValue
        case self.warmupPickerView:
            return 11 // 5 - 15 seconds
        case self.durationTimerView:
            return 3600
        default:
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        switch pickerView {
        case self.typePickerView:
            return ExerciseType(rawValue: row)!.localizedName()
        case self.warmupPickerView:
            return "\(row + 5) " + NSLocalizedString("SECONDS", comment: "seconds")
        case self.durationTimerView:
            return "\(row + 1) " + NSLocalizedString("SECONDS", comment: "seconds")
        default:
            return ""
        }
    }
}
