//
//  OpenAIService.swift
//  WatchPT
//
//  Created by admin on 4/19/25.
//

import Foundation

// MARK: – 모델 정의
struct ChatMessage: Codable {
    let role: String       // "user" 또는 "assistant"
    let content: String    // 실제 텍스트
}

struct ChatRequest: Codable {
    let model: String
    let messages: [ChatMessage]
}

struct ChatResponse: Codable {
    struct Choice: Codable {
        let message: ChatMessage
    }
    let choices: [Choice]
}

// MARK: – 서비스 클래스
class OpenAIService {
    // Secrets.plist에서 키 불러오기
    private var apiKey: String {
        guard
            let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path),
            let key = dict["OPENAI_API_KEY"] as? String
        else {
            fatalError("⚠️ Secrets.plist에 OPENAI_API_KEY가 없습니다.")
        }
        return key
    }

    /// GPT-4 Chat Completions 호출
    /// - Parameter messages: 주고받을 메시지 배열
    /// - Returns: Assistant의 응답 문자열
//    func sendChat(messages: [ChatMessage]) async throws -> String {
//        // 1) 요청 URL
//        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//
//        // 2) 헤더
//        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        // 3) 바디(JSON 인코딩)
//        let body = ChatRequest(model: "gpt-4", messages: messages)
//        request.httpBody = try JSONEncoder().encode(body)
//
//        // 4) 네트워크 호출 (async/await)
//        let (data, response) = try await URLSession.shared.data(for: request)
//        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
//            throw URLError(.badServerResponse)
//        }
//
//        // 5) JSON 디코딩
//        let chatResponse = try JSONDecoder().decode(ChatResponse.self, from: data)
//        // 첫 번째 choice의 메시지 리턴
//        return chatResponse.choices.first!.message.content
//    }
    
    func sendChat(messages: [ChatMessage]) async throws -> String {
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ChatRequest(model: "gpt-3.5-turbo", messages: messages)
        request.httpBody = try JSONEncoder().encode(body)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let httpResp = response as? HTTPURLResponse, httpResp.statusCode != 200 {
                let bodyString = String(data: data, encoding: .utf8) ?? "<no body>"
                print("🔴 HTTP \(httpResp.statusCode)\n\(bodyString)")
                throw URLError(.badServerResponse)
            }
            let chatResponse = try JSONDecoder().decode(ChatResponse.self, from: data)
            return chatResponse.choices.first!.message.content
        } catch {
            print("🔴 sendChat error:", error)
            throw error
        }
    }

}

