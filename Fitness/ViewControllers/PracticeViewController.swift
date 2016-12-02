//
//  PracticeViewController.swift
//  Fitness
//
//  Created by Manuel Leitold on 12.09.15.
//  Copyright © 2015 - 2016 mani1337. All rights reserved.
//

import UIKit

class PracticeViewController: ActiveTrainingChildViewController {

    // Enumerations
    fileprivate enum State {
        case warmup, practice, unknownOrFinished
    }
    
    // Storyboard outlets
    @IBOutlet weak var timerView: ExerciseTimerView!
    
    // Class vars
    fileprivate var timer: Timer!
    fileprivate var oldSpeakerTimerState = State.unknownOrFinished
    fileprivate var wasAppInactive = false
    
    // Computed vars
    fileprivate var state: State {
        // is warmup?
        if Date().timeIntervalSince1970 <= Date(timeInterval: self.exercise.warmup, since: self.startDate as Date).timeIntervalSince1970 {
            return .warmup
        }
        
        // is exercise?
        if Date().timeIntervalSince1970 <= Date(timeInterval: self.exercise.duration + self.exercise.warmup, since: self.startDate as Date).timeIntervalSince1970 {
            return .practice
        }
        
        // Maybe finished?
        return .unknownOrFinished
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.stopTimer()
    }
    
    override func appDidEnterBackground() {
        let app = UIApplication.shared
 
        switch self.state {
        case .warmup:
            let notification = UILocalNotification()
            notification.fireDate = Date(timeInterval: self.exercise.warmup, since: self.startDate as Date)
            notification.alertBody = "WARMUPVIEWCONTROLLER_FINISHED_WARMUP".localized
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.timeZone = TimeZone.current
            app.scheduleLocalNotification(notification)
            
            fallthrough
        case .practice:
            let notification = UILocalNotification()
            notification.fireDate = Date(timeInterval: self.exercise.duration, since: Date(timeInterval: self.exercise.warmup, since: self.startDate as Date))
            notification.alertBody = "PRACTICEVIEWCONTROLLER_FINISHED_WARMUP".localized
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.timeZone = TimeZone.current
            app.scheduleLocalNotification(notification)
            
        default:
            break
        }
        
        self.stopTimer()
    }
    
    override func appDidEnterForeground() {
        UIApplication.shared.cancelAllLocalNotifications()

        self.wasAppInactive = true
        self.startTimer()
    }
    
    func startTimer() {
        self.onTimer()
        self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(PracticeViewController.onTimer), userInfo: nil, repeats: true)
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
        case .practice where self.oldSpeakerTimerState == .warmup:
            self.titleLabel.text = "PRACTICEVIEWCONTROLLER_PRACTICE".localized
            self.timerView.maxProgress = self.exercise.duration
            
            // Don't speak when the application wakes up
            if !self.wasAppInactive {
                Speaker.sharedSpeaker().speakText("SPEAKTEXT_BEGIN_EXERCISE".localized)
            }
            
        // Practice -> Finished
        case .unknownOrFinished where self.oldSpeakerTimerState == .practice:
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
        case .warmup:
            timeDiffSinceStart = Date().timeIntervalSince(startDate as Date)
            progress = self.timerView.maxProgress - timeDiffSinceStart
            
        case .practice:
            timeDiffSinceStart = Date(timeIntervalSince1970: self.startDate.timeIntervalSince1970 + self.exercise.warmup).timeIntervalSinceNow * (-1)
            progress = self.timerView.maxProgress - timeDiffSinceStart
            
        case .unknownOrFinished:
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
