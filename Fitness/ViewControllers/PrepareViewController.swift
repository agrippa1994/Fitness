//
//  PrepareViewController.swift
//  Fitness
//
//  Created by Manuel Stampfl on 12.09.15.
//  Copyright © 2015 mani1337. All rights reserved.
//

import UIKit

class PrepareViewController: ActiveTrainingChildViewController {
    
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBAction func onStart(sender: AnyObject) {
        self.delegate?.activeTrainingChildViewControllerOnNext(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mainLabel.text = ExerciseType(rawValue: self.exercise.exerciseType)?.localizedName()

    }

}
