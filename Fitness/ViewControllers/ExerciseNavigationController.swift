//
//  ExerciseNavigationController.swift
//  Fitness
//
//  Created by Manuel Stampfl on 23.06.15.
//  Copyright (c) 2015 mani1337. All rights reserved.
//

import UIKit

@objc protocol ExerciseNavigationControllerDataSource {
    
}

@objc protocol ExerciseNavigationControllerDelegate {
    
}

class ExerciseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    private func createPrepareViewController() -> ExercisePrepareViewController {
        return self.storyboard!.instantiateViewControllerWithIdentifier("ExercisePrepareViewController") as! ExercisePrepareViewController
    }
    
    private func createWarmupViewController() -> ExerciseWarmupViewController {
        return self.storyboard!.instantiateViewControllerWithIdentifier("ExerciseWarmupViewController") as! ExerciseWarmupViewController
    }
}
