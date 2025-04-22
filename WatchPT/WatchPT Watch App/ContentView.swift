//
//  ContentView.swift
//  WatchPT Watch App
//
//  Created by admin on 4/19/25.
//

import SwiftUI
import AVFoundation
import WatchConnectivity

struct ContentView: View {
    @EnvironmentObject var sessionDelegate: WatchSessionDelegate
    @State private var requestText = ""
    @State private var responseText = ""
    
    let aiService = OpenAIService()

    var body: some View {
        VStack(spacing: 12) {
            // iOS에서 보내온 음성 인식 텍스트 표시
            if !sessionDelegate.receivedText.isEmpty {
                Text("음성 입력: \(sessionDelegate.receivedText)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // 요청 메시지 표시 (빈 문자열일 땐 숨김)
            if !requestText.isEmpty {
                Text("요청: \(requestText)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }

            // 응답 메시지 표시
            if !responseText.isEmpty {
                Text("응답: \(responseText)")
                    .font(.body)
                    .multilineTextAlignment(.center)
            } else {
                // 초기 안내 문구
                Text("여기에 GPT 응답이 표시됩니다")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }

            Spacer()
            
            // GPT 호출
            Button("GPT 대답 듣기") {
                Task {
                    
                    let userMessage = sessionDelegate.receivedText
                    requestText = userMessage
                    
                    do {
                        let reply = try await aiService.sendChat(
                            messages: [ChatMessage(role: "user", content: userMessage)]
                        )
                        // 화면에 텍스트 표시
                        responseText = reply
                        /// 음성으로 읽기
                        SpeechService.shared.speak(reply)
                    } catch {
                        responseText = "에러 발생: \(error.localizedDescription)"
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
        }
        .padding()
    }
}
