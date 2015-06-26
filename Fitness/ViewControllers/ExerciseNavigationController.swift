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

class ExerciseNavigationController: UINavigationController, ExerciseNavigationChildControllerDelegate, ExercisePrepareViewControllerDelegate {
    // MARK: - Vars
    weak var exerciseDelegate: ExerciseNavigationControllerDelegate?
    var training: Training!
    var currentExerciseNumber = 1
    
    // MARK: - Overrided Base Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.training.exercises.isEmpty {
            NSLog("Exercises are empty")
            return
        }
        
        let vc = self.createPrepareViewControllerForExercise(self.training.exercises[0])
        self.pushViewController(vc, animated: true)
    }

    // MARK: - Private member functions
    private func createViewControllerForExercise<T: ExerciseNavigationChildController>(exercise: Exercise, identifier: String) -> T{
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier(identifier) as! T
        vc.childDelegate = self
        vc.trainingProgress = (self.currentExerciseNumber, self.training.exercises.count)
        vc.exercise = exercise
        return vc
    }
    
    private func createPrepareViewControllerForExercise(exercise: Exercise) -> ExercisePrepareViewController {
        let vc: ExercisePrepareViewController = self.createViewControllerForExercise(exercise, identifier: "ExercisePrepareViewController")
        vc.delegate = self
        return vc
    }
    
    private func createWarmupViewControllerForExercise(exercise: Exercise) -> ExerciseWarmupViewController {
        let vc: ExerciseWarmupViewController = self.createViewControllerForExercise(exercise, identifier: "ExerciseWarmupViewController")
        //vc.delegate = self
        return vc
    }
    
    // MARK: - ExerciseNavigationChildControllerDelegate
    func exerciseNavigationChildControllerClose(controller: ExerciseNavigationChildController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - ExercisePrepareViewControllerDelegate
    func exercisePrepareViewControllerGo(controller: ExercisePrepareViewController) {
        let vc = createWarmupViewControllerForExercise(controller.exercise)
        self.pushViewController(vc, animated: true)
    }
}
