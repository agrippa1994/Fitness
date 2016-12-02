//
//  ActiveTrainingController.swift
//  Fitness
//
//  Created by Manuel Leitold on 12.09.15.
//  Copyright © 2015 - 2016 mani1337. All rights reserved.
//

import UIKit

@objc protocol ActiveTrainingControllerDelegate {
    func activeTrainingControllerDidCancelled(_ controller: ActiveTrainingController)
    func activeTrainingControllerDidFinished(_ controller: ActiveTrainingController)
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
                self.storyboard.instantiateViewController(withIdentifier: "PrepareViewController") as! ActiveTrainingChildViewController,
                self.storyboard.instantiateViewController(withIdentifier: "PracticeViewController") as! ActiveTrainingChildViewController
            ]
            
            for controller in newControllers {
                controller.exercise = exercise as! Exercise
                controller.activeTraining = self.activeTraining
                controller.startDate = Date()
            }

            self.controllers += newControllers
        }
        
        // Create the navigation controller
        self.navigationController = UINavigationController(rootViewController: self.controllers[0])
    
        // Hide navigation bar
        self.navigationController.setNavigationBarHidden(true, animated: false)
        
        super.init()
    }
    
    func createViewControllerViaStoryboard<T>(_ storyboard: UIStoryboard, withIdentifier identifier: String) -> T {
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
    
    func startViaController(_ controller: UIViewController) {
        // Add all view controllers to the navigation stack
        for controller in self.controllers {
            controller.delegate = self
        }
        
        self.navigationController.modalPresentationStyle = .popover
        self.navigationController.presentationController?.delegate = self

        controller.present(self.navigationController, animated: true, completion: nil)
    }
    
    func dismissViewControllerAnimated(_ flag: Bool, completion: (() -> Void)?) {
        self.navigationController.dismiss(animated: flag, completion: completion)
    }
    
    // MARK: - UIPopoverPresentationControllerDelegate
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .overFullScreen
    }
    
    // MARK: - ActiveTrainingChildViewControllerDelegate
    func activeTrainingChildViewControllerDidCancel(_ controller: ActiveTrainingChildViewController) {
        guard let _ = self.delegate?.activeTrainingControllerDidCancelled(self) else {
            return self.navigationController.dismiss(animated: true, completion: nil)
        }
        
        self.navigationController.dismiss(animated: true, completion: nil)
    }
    
    func activeTrainingChildViewControllerOnBack(_ controller: ActiveTrainingChildViewController) {
        self.currentViewControllerOffset -= 1
        self.navigationController.popViewController(animated: true)
    }
    
    func activeTrainingChildViewControllerOnNext(_ controller: ActiveTrainingChildViewController) {
        self.currentViewControllerOffset += 1
        
        if self.currentViewControllerOffset >= self.controllers.count {
            Health.sharedHealth().addWorkout(Date(timeIntervalSince1970: self.activeTraining.startDate), end: Date()) {
                NSLog("Store training to HealthKit: \($0)")
            }
            
            guard let _ = self.delegate?.activeTrainingControllerDidFinished(self) else {
                return self.navigationController.dismiss(animated: true, completion: nil)
            }
        } else {
            self.controllers[currentViewControllerOffset].startDate = Date()
            self.navigationController.pushViewController(self.controllers[currentViewControllerOffset], animated: true)
        }
    }
}
