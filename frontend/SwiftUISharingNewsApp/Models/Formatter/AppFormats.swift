//
//  AppFormats.swift
//  SwiftUISharingNewsApp
//
//  Created by Leo Ho on 2025/11/30.
//

import Foundation

struct AppFormats {
    
}

// MARK: - Date Formatters

extension AppFormats {
    
    /// 後端 API 要求的日期格式化器 (yyyy-MM-dd, GMT)
    ///
    /// 範例輸出：2025-11-30
    ///
    /// 使用範例：
    /// ```swift
    /// import Foundation
    ///
    /// let startDate = Date()
    /// let startDateFormatted = startDate.formatted(AppFormats.backend)
    /// ```
    static let backend = Date.ISO8601FormatStyle(timeZone: TimeZone(secondsFromGMT: 0)!)
        .year()
        .month()
        .day()
        .dateSeparator(.dash)
    
    /// 顯示於 UI 的日期格式化器 (medium style)
    ///
    /// 範例輸出：2025年11月30日
    ///
    /// 使用範例：
    /// ```swift
    /// import Foundation
    ///
    /// let startDate = Date()
    /// let startDateFormatted = startDate.formatted(AppFormats.display)
    /// ```
    static let display = Date.FormatStyle(
        date: .abbreviated,
        time: .omitted,
        locale: .autoupdatingCurrent,
        calendar: Calendar(identifier: .gregorian)
    )
}
