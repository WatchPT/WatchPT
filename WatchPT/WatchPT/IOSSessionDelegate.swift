//
//  IOSSessionDelegate.swift
//  WatchPT
//
//  Created by admin on 4/21/25.
//

import Foundation
import WatchConnectivity

final class IOSSessionDelegate: NSObject, WCSessionDelegate {
    // 세션 활성화
    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {
        if let error = error {
            print("▶️ WCSession activation failed:", error)
        } else {
            print("▶️ WCSession activated:", activationState.rawValue)
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        // watch OS 비활성화 콜백
    }
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
}

