//
//  WatchSessionDelegate.swift
//  WatchPT Watch App
//
//  Created by admin on 4/21/25.
//

import Foundation
import WatchConnectivity

/// iOS와 Watch 간 메시지를 주고받는 델리게이트
final class WatchSessionDelegate: NSObject, ObservableObject, WCSessionDelegate {
    @Published var receivedText = ""  // iOS에서 온 텍스트가 여기에 저장됩니다

    override init() {
        super.init()
        guard WCSession.isSupported() else { return }
        let session = WCSession.default
        session.delegate = self
        session.activate()
    }

    // 워치 쪽 세션 활성화 완료 콜백
    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {
        // 필요하면 로그 남기기
    }

    // iOS에서 sendMessage로 보낸 메시지 수신
    func session(_ session: WCSession,
                 didReceiveMessage message: [String : Any]) {
        if let speech = message["speech"] as? String {
            DispatchQueue.main.async {
                self.receivedText = speech
            }
        }
    }
}

