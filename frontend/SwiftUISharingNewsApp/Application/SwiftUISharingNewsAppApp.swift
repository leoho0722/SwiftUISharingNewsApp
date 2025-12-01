//
//  SwiftUISharingNewsAppApp.swift
//  SwiftUISharingNewsApp
//
//  Created by Leo Ho on 2025/11/1.
//

import SwiftUI
import SwiftData

@main
struct SwiftUISharingNewsAppApp: App {
    
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
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(sharedModelContainer)
    }
}
