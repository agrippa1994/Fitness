//
//  ActiveTrainingChildViewController.swift
//  Fitness
//
//  Created by Manuel Stampfl on 12.09.15.
//  Copyright © 2015 mani1337. All rights reserved.
//

import UIKit

@objc protocol ActiveTrainingChildViewControllerDelegate {
    func activeTrainingChildViewControllerDidCancel(controller: ActiveTrainingChildViewController)
    func activeTrainingChildViewControllerOnBack(controller: ActiveTrainingChildViewController)
    func activeTrainingChildViewControllerOnNext(controller: ActiveTrainingChildViewController)
}

class ActiveTrainingChildViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel?
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var backButton: UIButton?
    @IBOutlet weak var trainingProgressBar: UIProgressView!
    weak var delegate: ActiveTrainingChildViewControllerDelegate?
    
    var exercise: Exercise!
    var activeTraining: ActiveTraining!
    
    @IBAction func onCancel(sender: AnyObject) {
        // Display an alert controller
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "ACTIVETRAININGCHILDVIEWCONTROLLER_CANCEL_TRAINING".localized, style: .Destructive) { _ in
            self.delegate?.activeTrainingChildViewControllerDidCancel(self)
        })
        
        alert.addAction(UIAlertAction(title: "CANCEL".localized, style: .Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func onBack(sender: AnyObject) {
        self.delegate?.activeTrainingChildViewControllerOnBack(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let index = Float(self.activeTraining.currentTraining!.exercises!.indexOfObject(self.exercise))
        let count = Float(self.activeTraining.currentTraining!.exercises!.count)
        
        // Update the progress bar
        self.trainingProgressBar.progress = index / count
        
        // Register notifications
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: Selector("appDidEnterBackground"), name: UIApplicationDidEnterBackgroundNotification, object: nil)
        center.addObserver(self, selector: Selector("appDidEnterForeground"), name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Remove all notifications
        let center = NSNotificationCenter.defaultCenter()
        center.removeObserver(self)
    }
    
    // These methods can be overridden by a subclass
    func appDidEnterBackground() {
        
    }

    func appDidEnterForeground() {
        
    }
}
