//
//  ExerciseTableViewController.swift
//  Fitness
//
//  Created by Manuel Stampfl on 11.09.15.
//  Copyright © 2015 mani1337. All rights reserved.
//

import UIKit

extension Int {
    var asTime: String {
        if self < 60 {
            let seconds = self % 60
            let localizedSeconds = (seconds == 1 ? "SECOND" : "SECONDS").localized
            
            return "\(seconds) \(localizedSeconds)"
        } else {
            let minutes = self / 60
            let seconds = self % 60
            
            let localizedMinutes = (minutes == 1 ? "MINUTE" : "MINUTES").localized
            let localizedSeconds = (seconds == 1 ? "SECOND" : "SECONDS").localized
            
            return "\(minutes) \(localizedMinutes), \(seconds) \(localizedSeconds)"
        }
    }
}

class ExerciseTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var typePickerView: UIPickerView!
    @IBOutlet weak var warmupPickerView: UIPickerView!
    @IBOutlet weak var durationPickerView: UIPickerView!
    @IBOutlet var pickerViews: [UIPickerView]!
    var exercise: Exercise!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for pickerView in self.pickerViews {
            pickerView.dataSource = self
            pickerView.delegate = self
        }
        
        self.typePickerView.selectRow(Int(exercise.exerciseType), inComponent: 0, animated: false)
        self.warmupPickerView.selectRow(Int(exercise.warmup) - 5, inComponent: 0, animated: false)
        self.durationPickerView.selectRow(Int(exercise.duration) - 10, inComponent: 0, animated: false)
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        CoreData.save()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.exercise.exerciseType = Int32(self.typePickerView.selectedRowInComponent(0))
        self.exercise.warmup = Double(self.warmupPickerView.selectedRowInComponent(0)) + 5.0
        self.exercise.duration = Double(self.durationPickerView.selectedRowInComponent(0)) + 10.0
        
        CoreData.save()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return [
            self.typePickerView: Int(ExerciseType.Count.rawValue),
            self.warmupPickerView: 6,
            self.durationPickerView: 3600
        ][pickerView]!
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case self.typePickerView:
            return ExerciseType(rawValue: Int32(row))!.localizedName()
        case self.warmupPickerView:
            return (row + 5).asTime
        case self.durationPickerView:
            return (row + 10).asTime
        default:
            return nil
        }
    }
}
