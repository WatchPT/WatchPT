//
//  WatchPTApp.swift
//  WatchPT
//
//  Created by admin on 4/19/25.
//

import SwiftUI
import WatchConnectivity

@main
struct WatchPTApp: App {
    private let sessionDelegate = IOSSessionDelegate()
    
    init(){
        // 세션 활성화 & delegate 지정
        if WCSession.isSupported(){
            let session = WCSession.default
            session.delegate = sessionDelegate
            session.activate()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            IOSContentView()
        }
    }
}
