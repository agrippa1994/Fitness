//
//  ExerciseNavigationController.swift
//  Fitness
//
//  Created by Manuel Stampfl on 23.06.15.
//  Copyright (c) 2015 mani1337. All rights reserved.
//

import UIKit


@objc protocol ExerciseNavigationControllerDelegate {
    
}

class ExerciseNavigationController: UINavigationController {
    // MARK: - Vars
    weak var exerciseDelegate: ExerciseNavigationControllerDelegate?
    var training: Training?
    
    // MARK: - Overrided Base Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Private member functions
    private func createPrepareViewController() -> ExercisePrepareViewController {
        return self.storyboard!.instantiateViewControllerWithIdentifier("ExercisePrepareViewController") as! ExercisePrepareViewController
    }
    
    private func createWarmupViewController() -> ExerciseWarmupViewController {
        return self.storyboard!.instantiateViewControllerWithIdentifier("ExerciseWarmupViewController") as! ExerciseWarmupViewController
    }
}
