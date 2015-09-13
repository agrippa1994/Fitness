//
//  SpeakText.swift
//  Fitness
//
//  Created by Manuel Stampfl on 12.09.15.
//  Copyright © 2015 mani1337. All rights reserved.
//

import AVFoundation

class Speaker {
    private static var _sharedSpeaker: Speaker?
    let synthesizer: AVSpeechSynthesizer
    var pitch: Float = 1.4
    var rate: Float = 0.5
    
    class func sharedSpeaker() -> Speaker {
        if _sharedSpeaker == nil {
            _sharedSpeaker = Speaker()
        }
        
        return _sharedSpeaker!
    }
    
    private init() {
        self.synthesizer = AVSpeechSynthesizer()
    }
    
    func speakText(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.preUtteranceDelay = 0.0
        utterance.pitchMultiplier = self.pitch
        utterance.rate = self.rate
        
        self.synthesizer.speakUtterance(utterance)
    }
}
