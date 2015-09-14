//
//  PracticeViewController.swift
//  Fitness
//
//  Created by Manuel Stampfl on 12.09.15.
//  Copyright © 2015 mani1337. All rights reserved.
//

import UIKit

class PracticeViewController: ActiveTrainingChildViewController {

    // Enumerations
    private enum State {
        case Warmup, Practice, UnknownOrFinished
    }
    
    // Storyboard outlets
    @IBOutlet weak var timerView: ExerciseTimerView!
    
    // Class vars
    private var timer: NSTimer!
    private var oldSpeakerTimerState = State.UnknownOrFinished
    private var wasAppInactive = false
    
    // Computed vars
    private var state: State {
        // is warmup?
        if NSDate().timeIntervalSince1970 <= NSDate(timeInterval: self.exercise.warmup, sinceDate: self.startDate).timeIntervalSince1970 {
            return .Warmup
        }
        
        // is exercise?
        if NSDate().timeIntervalSince1970 <= NSDate(timeInterval: self.exercise.duration + self.exercise.warmup, sinceDate: self.startDate).timeIntervalSince1970 {
            return .Practice
        }
        
        // Maybe finished?
        return .UnknownOrFinished
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.timerView.maxProgress = self.exercise.warmup
        self.timerView.progress = self.exercise.warmup
        
        self.titleLabel.text = "PRACTICEVIEWCONTROLLER_WARMUP".localized
        self.subLabel?.text = ExerciseType(rawValue: self.exercise.exerciseType)?.localizedName()
        self.timerView.text = "\(Int(self.exercise.duration))"
        
        // Initialize SpeakText
        Speaker.sharedSpeaker()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.startTimer()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.stopTimer()
    }
    
    override func appDidEnterBackground() {
        let app = UIApplication.sharedApplication()
 
        switch self.state {
        case .Warmup:
            let notification = UILocalNotification()
            notification.fireDate = NSDate(timeInterval: self.exercise.warmup, sinceDate: self.startDate)
            notification.alertBody = "WARMUPVIEWCONTROLLER_FINISHED_WARMUP".localized
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.timeZone = NSTimeZone.defaultTimeZone()
            app.scheduleLocalNotification(notification)
            
            fallthrough
        case .Practice:
            let notification = UILocalNotification()
            notification.fireDate = NSDate(timeInterval: self.exercise.duration, sinceDate: NSDate(timeInterval: self.exercise.warmup, sinceDate: self.startDate))
            notification.alertBody = "PRACTICEVIEWCONTROLLER_FINISHED_WARMUP".localized
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.timeZone = NSTimeZone.defaultTimeZone()
            app.scheduleLocalNotification(notification)
            
        default:
            break
        }
        
        self.stopTimer()
    }
    
    override func appDidEnterForeground() {
        UIApplication.sharedApplication().cancelAllLocalNotifications()

        self.wasAppInactive = true
        self.startTimer()
    }
    
    func startTimer() {
        self.onTimer()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("onTimer"), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        self.timer.invalidate()
    }

    func onTimer() {
        udpateSpeak()
        updateTrainingAndGUI()
    }
    
    func udpateSpeak() {
        let currentState = self.state
        
        defer {
            self.oldSpeakerTimerState = currentState
            self.wasAppInactive = false
        }
        
        switch currentState {
        // Warmup -> Practice
        case .Practice where self.oldSpeakerTimerState == .Warmup:
            self.titleLabel.text = "PRACTICEVIEWCONTROLLER_PRACTICE".localized
            self.timerView.maxProgress = self.exercise.duration
            
            // Don't speak when the application wakes up
            if !self.wasAppInactive {
                Speaker.sharedSpeaker().speakText("SPEAKTEXT_BEGIN_EXERCISE".localized)
            }
            
        // Practice -> Finished
        case .UnknownOrFinished where self.oldSpeakerTimerState == .Practice:
            // Don't speak when the application wakes up
            if !self.wasAppInactive {
                Speaker.sharedSpeaker().speakText("SPEAKTEXT_EXERCISE_FINISHED".localized)
            }
            
        default:
            break
        }
    }
    
    func updateTrainingAndGUI() {
        let progress: Double
        let timeDiffSinceStart: Double
        
        switch self.state {
        case .Warmup:
            timeDiffSinceStart = NSDate().timeIntervalSinceDate(startDate)
            progress = self.timerView.maxProgress - timeDiffSinceStart
            
        case .Practice:
            timeDiffSinceStart = NSDate(timeIntervalSince1970: self.startDate.timeIntervalSince1970 + self.exercise.warmup).timeIntervalSinceNow * (-1)
            progress = self.timerView.maxProgress - timeDiffSinceStart
            
        case .UnknownOrFinished:
            timeDiffSinceStart = 0.0
            progress = 0.0
            
            self.stopTimer()
            self.delegate?.activeTrainingChildViewControllerOnNext(self)
            return
        }
        
        self.timerView.text = "\(Int(progress) + 1)"
        if progress <= 0 {
            self.timerView.progress = 0.0
            self.timerView.text = "0"
            
            return
        }
        
        self.timerView.progress = progress
    }
}
