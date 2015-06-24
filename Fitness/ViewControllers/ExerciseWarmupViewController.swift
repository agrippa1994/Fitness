//
//  ExerciseWarmupViewController.swift
//  Fitness
//
//  Created by Manuel Stampfl on 23.06.15.
//  Copyright (c) 2015 mani1337. All rights reserved.
//

import UIKit

class ExerciseWarmupViewController: UIViewController {

    @IBOutlet weak var timerView: ExerciseTimerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "asdf"
        self.navigationItem.backBarButtonItem?.title = "1234"
        self.navigationItem.leftBarButtonItem?.title = "4321"
        
        self.timerView.text = "888"
        self.timerView.textSize = 30.0
    }
}
