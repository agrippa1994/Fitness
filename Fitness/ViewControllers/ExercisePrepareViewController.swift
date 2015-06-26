//
//  ExercisePrepareViewController.swift
//  Fitness
//
//  Created by Manuel Stampfl on 23.06.15.
//  Copyright (c) 2015 mani1337. All rights reserved.
//

import UIKit

@objc protocol ExercisePrepareViewControllerDelegate {
    func exercisePrepareViewControllerGo(controller: ExercisePrepareViewController)
}

class ExercisePrepareViewController: ExerciseNavigationChildController {
    // MARK: - Vars
    weak var delegate: ExercisePrepareViewControllerDelegate?
    
    // MARK: - Storyboard Outlets
    @IBOutlet weak var trainingNameLabel: UILabel!
    
    // MARK: - Storyboard Actions
    @IBAction func onGoButton(sender: AnyObject) {
        delegate?.exercisePrepareViewControllerGo(self)
    }
    
    // MARK: - Overrided Base Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.trainingNameLabel.text = self.exercise.type.localizedName()
    }
}
