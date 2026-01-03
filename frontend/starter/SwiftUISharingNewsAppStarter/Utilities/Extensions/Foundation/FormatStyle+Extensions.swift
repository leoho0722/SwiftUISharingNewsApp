//
//  FormatStyle+Extensions.swift
//  SwiftUISharingNewsAppStarter
//
//  Created by Leo Ho on 2025/11/30.
//

import Foundation

extension FormatStyle where Self == Date.ISO8601FormatStyle {
    
    /// 後端 API 要求的日期格式化器 (yyyy-MM-dd, GMT)
    ///
    /// 範例輸出：2025-11-30
    ///
    /// 使用範例：
    /// ```swift
    /// import Foundation
    ///
    /// let startDate = Date()
    /// let startDateFormatted = startDate.formatted(.backend)
    /// ```
    static var backend: Self {
        return AppFormats.backend
    }
}

extension FormatStyle where Self == Date.FormatStyle {
    
    /// 顯示於 UI 的日期格式化器 (medium style)
    ///
    /// 範例輸出：2025年11月30日
    ///
    /// 使用範例：
    /// ```swift
    /// import Foundation
    ///
    /// let startDate = Date()
    /// let startDateFormatted = startDate.formatted(.display)
    /// ```
    static var display: Self {
        return AppFormats.display
    }
}
