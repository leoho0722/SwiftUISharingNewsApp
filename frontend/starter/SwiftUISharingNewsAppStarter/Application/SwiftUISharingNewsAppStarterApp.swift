//
//  SwiftUISharingNewsAppStarterApp.swift
//  SwiftUISharingNewsAppStarter
//
//  Created by Leo Ho on 2025/11/1.
//

import SwiftUI

@main
struct SwiftUISharingNewsAppStarterApp: App {
    
    /// 全域網路狀態監控器
    @State private var networkMonitor = NetworkMonitor()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .task {
                    await networkMonitor.start()
                }
        }
        .environment(\.networkMonitor, networkMonitor)
    }
}
