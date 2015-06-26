//
//  ExerciseNavigationChildController.swift
//  Fitness
//
//  Created by Manuel Stampfl on 26.06.15.
//  Copyright (c) 2015 mani1337. All rights reserved.
//

import UIKit

@objc protocol ExerciseNavigationChildControllerDelegate {
    func exerciseNavigationChildControllerClose(controller: ExerciseNavigationChildController)
}

class ExerciseNavigationChildController: UIViewController {
    // MARK: - Vars
    weak var childDelegate: ExerciseNavigationChildControllerDelegate?
    var trainingProgress = (0, 0)
    var exercise: Exercise!
    var backEnabled = true
    
    @IBAction private func onClose(sender: AnyObject) {
        
        let cancelString = NSLocalizedString("EXERCISENAVIGATIONCHILDCONTROLLER_ACTIONSHEET_CANCEL", comment: "cancel")
        let cancelTrainingString = NSLocalizedString("EXERCISENAVIGATIONCHILDCONTROLLER_ACTIONSHEET_CANCEL_TRAINING", comment: "cancel training")
        
        var controller = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        controller.addAction(UIAlertAction(title: cancelString, style: .Cancel) { action in })
        controller.addAction(UIAlertAction(title: cancelTrainingString, style: .Destructive) { action in
            self.childDelegate?.exerciseNavigationChildControllerClose(self)
        })
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let format = NSLocalizedString("EXERCISE_NAVIGATION_CONTROLLER_PROMPT", comment: "prompt")
        self.navigationItem.prompt = String(format: format, arguments: [self.trainingProgress.0, self.trainingProgress.1])
        self.navigationItem.hidesBackButton = !self.backEnabled
    }
}
