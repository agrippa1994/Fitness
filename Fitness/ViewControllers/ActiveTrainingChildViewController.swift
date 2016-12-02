//
//  ActiveTrainingChildViewController.swift
//  Fitness
//
//  Created by Manuel Leitold on 12.09.15.
//  Copyright © 2015 - 2016 mani1337. All rights reserved.
//

import UIKit

@objc protocol ActiveTrainingChildViewControllerDelegate {
    func activeTrainingChildViewControllerDidCancel(_ controller: ActiveTrainingChildViewController)
    func activeTrainingChildViewControllerOnBack(_ controller: ActiveTrainingChildViewController)
    func activeTrainingChildViewControllerOnNext(_ controller: ActiveTrainingChildViewController)
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
    var startDate: Date!
    
    @IBAction func onCancel(_ sender: AnyObject) {
        // Display an alert controller
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "ACTIVETRAININGCHILDVIEWCONTROLLER_CANCEL_TRAINING".localized, style: .destructive) { _ in
            self.delegate?.activeTrainingChildViewControllerDidCancel(self)
        })
        
        alert.addAction(UIAlertAction(title: "CANCEL".localized, style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onBack(_ sender: AnyObject) {
        self.delegate?.activeTrainingChildViewControllerOnBack(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let index = Float(self.activeTraining.currentTraining!.exercises!.index(of: self.exercise))
        let count = Float(self.activeTraining.currentTraining!.exercises!.count)
        
        // Update the progress bar
        self.trainingProgressBar.progress = index / count
        
        // Register notifications
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(ActiveTrainingChildViewController.appDidEnterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        center.addObserver(self, selector: #selector(ActiveTrainingChildViewController.appDidEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Remove all notifications
        let center = NotificationCenter.default
        center.removeObserver(self)
    }
    
    // These methods can be overridden by a subclass
    func appDidEnterBackground() {
        
    }

    func appDidEnterForeground() {
        
    }
}
