//
//  WatchPTApp.swift
//  WatchPT Watch App
//
//  Created by admin on 4/19/25.
//

import SwiftUI
import WatchConnectivity

@main
struct WatchPT_Watch_App: App {

    var body: some Scene {
        WindowGroup {
            // ContentView에 환경 객체 주입
            ContentView()
                .environmentObject(WatchSessionDelegate())
        }
    }
    
}

