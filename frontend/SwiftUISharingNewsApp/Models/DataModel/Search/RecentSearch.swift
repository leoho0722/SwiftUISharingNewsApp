//
//  RecentSearch.swift
//  SwiftUISharingNewsApp
//
//  Created by Leo Ho on 2025/11/13.
//

import Foundation
import SwiftData

/// 使用者近期搜尋紀錄 (SwiftData)
/// 
/// - Version 1.0.0 (2025-11-13): 初始 schema。新增 `keyword`、`startDate`、`endDate` 與 `createdAt` 欄位，提供搜尋建議快取與一週內過期判斷。
///   - 目的：儲存最近一次搜尋條件，支援 `searchable` 建議、單筆/全部刪除與自動過期清理流程。
///   - 遷移影響：既有資料為空集合，不需轉換；未來版本若新增欄位，請在 MigrationPlan 與專案 Wiki 同步紀錄原因與影響。
@Model
final class RecentSearch {

    /// 任意搜尋關鍵字（可為空，僅使用日期篩選時為 `nil`）。
    var keyword: String?

    /// 篩選使用的開始日期。
    var startDate: Date?

    /// 篩選使用的結束日期。
    var endDate: Date?
    
    /// 建立時間，供一週自動過期判斷與排序使用。
    var createdAt: Date

    init(keyword: String?, startDate: Date?, endDate: Date?, createdAt: Date = .now) {
        self.keyword = keyword
        self.startDate = startDate
        self.endDate = endDate
        self.createdAt = createdAt
    }

    /// 更新既有紀錄並刷新建立時間，保持最近一次搜尋條件。
    func update(keyword: String?, startDate: Date?, endDate: Date?) {
        self.keyword = keyword
        self.startDate = startDate
        self.endDate = endDate
        createdAt = .now
    }
}
