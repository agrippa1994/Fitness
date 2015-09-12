//
//  SpeakText.swift
//  Fitness
//
//  Created by Manuel Stampfl on 12.09.15.
//  Copyright © 2015 mani1337. All rights reserved.
//

import AVFoundation

public func SpeakText(text: String, pitch: Float = 1.4, rate: Float = 0.5) {
    let utterance = AVSpeechUtterance(string: text)
    utterance.preUtteranceDelay = 0.0
    utterance.pitchMultiplier = pitch
    utterance.rate = rate
    AVSpeechSynthesizer().speakUtterance(utterance)
}
