//
//  ActiveTrainingController.swift
//  Fitness
//
//  Created by Manuel Stampfl on 12.09.15.
//  Copyright © 2015 mani1337. All rights reserved.
//

import UIKit

@objc protocol ActiveTrainingControllerDelegate {
    func activeTrainingControllerDidCancelled(controller: ActiveTrainingController)
    func activeTrainingControllerDidFinished(controller: ActiveTrainingController)
}

class ActiveTrainingController: NSObject, UIPopoverPresentationControllerDelegate, ActiveTrainingChildViewControllerDelegate {
    
    let storyboard: UIStoryboard
    let activeTraining: ActiveTraining
    let navigationController: UINavigationController
    var controllers: [ActiveTrainingChildViewController]
    var currentViewControllerOffset = 0
    weak var delegate: ActiveTrainingControllerDelegate?
    
    init(withStoryboard storyboard: UIStoryboard, andActiveTraining activeTraining: ActiveTraining) {
        self.storyboard = storyboard
        self.activeTraining = activeTraining
        
        // Create ViewControllers
        self.controllers = []
        for exercise in self.activeTraining.currentTraining!.exercises! {
            let newControllers = [
                self.storyboard.instantiateViewControllerWithIdentifier("PrepareViewController") as! ActiveTrainingChildViewController,
                self.storyboard.instantiateViewControllerWithIdentifier("PracticeViewController") as! ActiveTrainingChildViewController
            ]
            
            for controller in newControllers {
                controller.exercise = exercise as! Exercise
                controller.activeTraining = self.activeTraining
                controller.startDate = NSDate()
            }

            self.controllers += newControllers
        }
        
        // Create the navigation controller
        self.navigationController = UINavigationController(rootViewController: self.controllers[0])
    
        // Hide navigation bar
        self.navigationController.setNavigationBarHidden(true, animated: false)
        
        super.init()
    }
    
    func createViewControllerViaStoryboard<T>(storyboard: UIStoryboard, withIdentifier identifier: String) -> T {
        return storyboard.instantiateViewControllerWithIdentifier(identifier) as! T
    }
    
    func startViaController(controller: UIViewController) {
        // Add all view controllers to the navigation stack
        for controller in self.controllers {
            controller.delegate = self
        }
        
        self.navigationController.modalPresentationStyle = .Popover
        self.navigationController.presentationController?.delegate = self

        controller.presentViewController(self.navigationController, animated: true, completion: nil)
    }
    
    func dismissViewControllerAnimated(flag: Bool, completion: (() -> Void)?) {
        self.navigationController.dismissViewControllerAnimated(flag, completion: completion)
    }
    
    // MARK: - UIPopoverPresentationControllerDelegate
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .OverFullScreen
    }
    
    // MARK: - ActiveTrainingChildViewControllerDelegate
    func activeTrainingChildViewControllerDidCancel(controller: ActiveTrainingChildViewController) {
        guard let _ = self.delegate?.activeTrainingControllerDidCancelled(self) else {
            return self.navigationController.dismissViewControllerAnimated(true, completion: nil)
        }
        
        self.navigationController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func activeTrainingChildViewControllerOnBack(controller: ActiveTrainingChildViewController) {
        self.currentViewControllerOffset -= 1
        self.navigationController.popViewControllerAnimated(true)
    }
    
    func activeTrainingChildViewControllerOnNext(controller: ActiveTrainingChildViewController) {
        self.currentViewControllerOffset += 1
        
        if self.currentViewControllerOffset >= self.controllers.count {
            Health.sharedHealth().addWorkout(NSDate(timeIntervalSince1970: self.activeTraining.startDate), end: NSDate()) {
                NSLog("Store training to HealthKit: \($0)")
            }
            
            guard let _ = self.delegate?.activeTrainingControllerDidFinished(self) else {
                return self.navigationController.dismissViewControllerAnimated(true, completion: nil)
            }
        } else {
            self.controllers[currentViewControllerOffset].startDate = NSDate()
            self.navigationController.pushViewController(self.controllers[currentViewControllerOffset], animated: true)
        }
    }
}