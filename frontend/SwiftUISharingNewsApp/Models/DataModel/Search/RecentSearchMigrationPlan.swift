//
//  RecentSearchMigrationPlan.swift
//  SwiftUISharingNewsApp
//
//  Created by Leo Ho on 2025/11/13.
//

import SwiftData

/// RecentSearch SwiftData schema 定義。
///
/// - Version 1.0.0 (2025-11-13): 對應 `RecentSearch` 初版欄位組 (`keyword`、`startDate`、`endDate`、`createdAt`)。
///   - 目的：提供搜尋建議快取資料表的初始版本識別，作為未來 schema 擴充的比較基準。
///   - 遷移影響：現階段資料庫為空集合，無需額外遷移；若後續新增欄位或改動，請新增新版 schema 並撰寫對應 MigrationStage 與 Wiki 記錄。
enum RecentSearchSchemaV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)
    static var models: [any PersistentModel.Type] {
        [RecentSearch.self]
    }
}

/// RecentSearch SwiftData MigrationPlan。
///
/// - 說明：目前僅包含 `RecentSearchSchemaV1`，尚無遷移步驟；保持 `stages` 為空陣列即可。
/// - 注意：未來新增 schema 時，請依序追加新版本與 MigrationStage，並確保與 Wiki 以及模型註解同步更新。
/// 
/// ### 範例：新增 `RecentSearchSchemaV2` 並加入遷移階段
/// ```swift
/// enum RecentSearchSchemaV2: VersionedSchema {
///     static var versionIdentifier = Schema.Version(2, 0, 0)
///     static var models: [any PersistentModel.Type] { [RecentSearch.self] }
/// }
/// 
/// enum RecentSearchMigrationPlan: SchemaMigrationPlan {
///     static var schemas: [any VersionedSchema.Type] {
///         [RecentSearchSchemaV1.self, RecentSearchSchemaV2.self]
///     }
/// 
///     static var stages: [MigrationStage] {
///         [
///             .lightweight(from: RecentSearchSchemaV1.self, to: RecentSearchSchemaV2.self)
///         ]
///     }
/// }
/// ```
enum RecentSearchMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [RecentSearchSchemaV1.self]
    }

    static var stages: [MigrationStage] {
        []
    }
}
