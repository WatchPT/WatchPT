//
//  ContentView.swift
//  WatchPT
//
//  Created by admin on 4/19/25.
//

import SwiftUI
import WatchConnectivity

struct IOSContentView: View {
    @StateObject private var stt = SpeechRecognitionService()
    @State private var isRecording = false

    var body: some View {
        VStack(spacing: 20) {
            Text(isRecording ? "말하는 중…" : "버튼을 눌러 시작")
                .font(.title2)

            Text(stt.recognizedText)
                .padding()
                .multilineTextAlignment(.center)

            Button(isRecording ? "정지" : "녹음 시작") {
                if isRecording {
                    stt.stopRecording()
                } else {
                    try? stt.startRecording()
                }
                isRecording.toggle()
            }
            .buttonStyle(.borderedProminent)
            .padding()

            // 워치로 텍스트 전송 버튼
            Button("워치로 보내기") {
                sendToWatch(stt.recognizedText)
            }
        }
        .onAppear {
            stt.requestAuthorization { granted in
                if !granted {
                    // 권한 거부 안내...
                }
            }

            // ② 워치 연결 세션 활성화
            if WCSession.isSupported() {
             WCSession.default.activate()
            }
        }
        .padding()
    }

    func sendToWatch(_ text: String) {
        guard WCSession.default.isReachable else { return }
        WCSession.default.sendMessage(
            ["speech": text],
            replyHandler: nil,
            errorHandler: { error in
                    print("워치 전송 실패:",error)
            }
        )
    }
}

