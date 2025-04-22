//
//  SpeechService.swift
//  WatchPT
//
//  Created by admin on 4/20/25.
//

import AVFoundation

final class SpeechService {
    static let shared = SpeechService()
    private let synthesizer = AVSpeechSynthesizer()

    private init() {}

    /// 텍스트를 음성으로 읽어줍니다.
    func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        // 한국어 음성으로 설정 (영어는 "en-US" 등)
        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        // 속도 조절 (기본값의 0.5배)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 1
        synthesizer.speak(utterance)
    }
}

