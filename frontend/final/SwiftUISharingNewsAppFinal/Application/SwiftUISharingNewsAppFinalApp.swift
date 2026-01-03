//
//  SwiftUISharingNewsAppFinalApp.swift
//  SwiftUISharingNewsAppFinal
//
//  Created by Leo Ho on 2025/11/1.
//

import SwiftUI
import SwiftData

@main
struct SwiftUISharingNewsAppFinalApp: App {
    
    /// 供全域共用的 SwiftData ModelContainer，使用 `RecentSearchMigrationPlan` 確保 schema 可持續演進。
    private let sharedModelContainer: ModelContainer = {
        do {
            return try ModelContainer(
                for: RecentSearch.self,
                migrationPlan: RecentSearchMigrationPlan.self
            )
        } catch {
            fatalError("無法建立 SwiftData ModelContainer：\(error.localizedDescription)")
        }
    }()
    
    /// 全域網路狀態監控器
    @State private var networkMonitor = NetworkMonitor()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .task {
                    await networkMonitor.start()
                }
        }
        .modelContainer(sharedModelContainer)
        .environment(\.networkMonitor, networkMonitor)
    }
}
