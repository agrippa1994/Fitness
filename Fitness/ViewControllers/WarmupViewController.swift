//
//  WarmupViewController.swift
//  Fitness
//
//  Created by Manuel Stampfl on 12.09.15.
//  Copyright © 2015 mani1337. All rights reserved.
//

import UIKit
import AVFoundation

class WarmupViewController: ActiveTrainingChildViewController {

    @IBOutlet weak var timerView: ExerciseTimerView!
    var timer: NSTimer!
    var startDate: NSDate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.timerView.maxProgress = self.exercise.warmup
        self.timerView.progress = self.exercise.warmup
        
        self.subLabel?.text = ExerciseType(rawValue: self.exercise.exerciseType)?.localizedName()
        self.timerView.text = "\(Int(self.exercise.warmup))"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.startDate = NSDate()
        self.onTimer()
        self.startTimer()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.stopTimer()
    }
    
    override func appDidEnterBackground() {
        let app = UIApplication.sharedApplication()
        let notification = UILocalNotification()
        
        notification.fireDate = NSDate(timeInterval: self.exercise.warmup, sinceDate: self.startDate)
        notification.alertBody = "WARMUPVIEWCONTROLLER_FINISHED_WARMUP".localized
        notification.soundName = UILocalNotificationDefaultSoundName
        
        notification.timeZone = NSTimeZone.defaultTimeZone()
        app.scheduleLocalNotification(notification)
        self.stopTimer()
        
    }
    
    override func appDidEnterForeground() {
        let app = UIApplication.sharedApplication()
        app.cancelAllLocalNotifications()
        
        self.onTimer()
        self.startTimer()
    }
    
    func startTimer() {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: Selector("onTimer"), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        self.timer.invalidate()
    }
    
    func onTimer() {
        let time = NSDate().timeIntervalSinceDate(startDate)
        let progress = self.timerView.maxProgress - time
        
        self.timerView.text = "\(Int(progress) + 1)"
        
        if progress <= 0 {
            self.timerView.progress = 0.0
            self.delegate?.activeTrainingChildViewControllerOnNext(self)
            self.stopTimer()
        } else {
            self.timerView.progress = self.timerView.maxProgress - time
        }
    }
    
}
