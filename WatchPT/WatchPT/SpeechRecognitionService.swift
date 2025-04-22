//
//  SpeechRecognitionService.swift
//  WatchPT
//
//  Created by admin on 4/20/25.
//

import Foundation
import Speech
import AVFoundation

final class SpeechRecognitionService: ObservableObject {
    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))!
    private let audioEngine = AVAudioEngine()
    private var request:  SFSpeechAudioBufferRecognitionRequest?
    private var task:     SFSpeechRecognitionTask?

    @Published var recognizedText = ""

    /// 1) 권한 요청
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                completion(authStatus == .authorized)
            }
        }
    }

    /// 2) 녹음 시작 & 인식
    func startRecording() throws {
        // 기존 작업이 있으면 취소
        task?.cancel()
        task = nil

        // 오디오 세션 설정
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.record, mode: .measurement, options: .duckOthers)
        try session.setActive(true, options: .notifyOthersOnDeactivation)

        // Recognition 요청
        request = SFSpeechAudioBufferRecognitionRequest()
        guard let request = request else { return }

        // 오디오 입력 노드
        let inputNode = audioEngine.inputNode
        request.shouldReportPartialResults = true

        // 인식 결과 처리
        task = recognizer.recognitionTask(with: request) { result, error in
            if let result = result {
                // 실시간 중간 결과도 가져옵니다
                DispatchQueue.main.async {
                    self.recognizedText = result.bestTranscription.formattedString
                }
            }

            if error != nil || (result?.isFinal ?? false) {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.request = nil
                self.task = nil
            }
        }

        // 오디오 버퍼를 RecognitionRequest에 공급
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            request.append(buffer)
        }

        audioEngine.prepare()
        try audioEngine.start()
    }

    /// 3) 녹음/인식 중지
    func stopRecording() {
        audioEngine.stop()
        request?.endAudio()
    }
}

