//
//  PracticeViewController.swift
//  Fitness
//
//  Created by Manuel Stampfl on 12.09.15.
//  Copyright © 2015 mani1337. All rights reserved.
//

import UIKit

class PracticeViewController: ActiveTrainingChildViewController {

    @IBOutlet weak var timerView: ExerciseTimerView!
    var timer: NSTimer!
    var startDate: NSDate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.timerView.maxProgress = self.exercise.duration
        self.timerView.progress = self.exercise.duration
        
        self.subLabel?.text = ExerciseType(rawValue: self.exercise.exerciseType)?.localizedName()
        self.timerView.text = "\(Int(self.exercise.duration))"
        
        // Initialize SpeakText
        SpeakText("")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        SpeakText("SPEAKTEXT_BEGIN_EXERCISE".localized)
        
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
        
        notification.fireDate = NSDate(timeInterval: self.exercise.duration, sinceDate: self.startDate)
        notification.alertBody = "PRACTICEVIEWCONTROLLER_FINISHED_WARMUP".localized
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
            SpeakText("SPEAKTEXT_EXERCISE_FINISHED".localized)
            self.timerView.progress = 0.0
            self.delegate?.activeTrainingChildViewControllerOnNext(self)
            self.stopTimer()
        } else {
            self.timerView.progress = self.timerView.maxProgress - time
        }
    }
}
