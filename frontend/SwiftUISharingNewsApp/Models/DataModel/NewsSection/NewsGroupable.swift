//
//  NewsGroupable.swift
//  SwiftUISharingNewsApp
//
//  Created by Leo Ho on 2025/11/4.
//

import Foundation

/// 排序方式 enum
enum SortOrder {
    
    /// 由新到舊
    case descending
    
    /// 由舊到新
    case ascending
}

/// 提供新聞分組功能的 Protocol
protocol NewsGroupable {

    /// 新聞列表
    var newsItems: [NewsItem] { get }

    /// 提供給 UI 的分組後 Section
    /// 
    /// - Note: 預設實作依日期由新到舊排序，可由遵循的類別覆寫
    var groupedSections: [NewsSection] { get }
}

// MARK: - Default Implementation

extension NewsGroupable {
    
    /// 預設實作: 依日期由新到舊排序
    var groupedSections: [NewsSection] {
        groupNewsByDate(newsItems, sortOrder: .descending)
    }
}

// MARK: - Helpers Methods

extension NewsGroupable {
    
    /// 將新聞列表依日期分組並排序
    /// 
    /// - Parameters:
    ///   - newsItems: 新聞列表
    ///   - sortOrder: 排序方式
    /// - Returns: 分組後的 Section 陣列
    func groupNewsByDate(
        _ newsItems: [NewsItem],
        sortOrder: SortOrder = .descending
    ) -> [NewsSection] {
        let calendar = Calendar(identifier: .gregorian)
        
        // 轉為 (normalizedDate, item)
        let pairs: [(Date, NewsItem)] = newsItems.compactMap { item in
            guard let date = backendDateFormatter.date(from: item.publishDate) else {
                return nil
            }
            // 以本地時區取年月日,建立不含時間的日期
            let comps = calendar.dateComponents(in: .current, from: date)
            let normalizedComponents = DateComponents(
                calendar: calendar,
                timeZone: .current,
                year: comps.year,
                month: comps.month,
                day: comps.day
            )
            guard let dayDate = calendar.date(from: normalizedComponents) else {
                return nil
            }
            return (dayDate, item)
        }
        
        // 分組
        let grouped = Dictionary(grouping: pairs, by: { $0.0 }).mapValues { $0.map { $0.1 } }
        
        // 產生 Section 並排序
        let sections: [NewsSection] = grouped
            .map { date, items in
                NewsSection(
                    id: date,
                    sectionTitle: displayDateFormatter.string(from: date),
                    items: items
                )
            }
            .sorted(by: { sortOrder == .descending ? $0.id > $1.id : $0.id < $1.id })
        
        return sections
    }
}

// MARK: - Date Formatters

extension NewsGroupable {
    
    /// 解析後端回傳的日期字串(例如 "2025-01-22")
    var backendDateFormatter: DateFormatter {
        let df = DateFormatter()
        df.calendar = Calendar(identifier: .gregorian)
        df.locale = Locale(identifier: "zh_TW")
        df.timeZone = TimeZone(secondsFromGMT: 0)
        df.dateFormat = "yyyy-MM-dd"
        return df
    }
    
    /// 顯示在 Section Header 的日期格式
    var displayDateFormatter: DateFormatter {
        let df = DateFormatter()
        df.calendar = Calendar(identifier: .gregorian)
        df.locale = Locale(identifier: "zh_TW")
        df.timeZone = .current
        df.dateFormat = "yyyy/MM/dd"
        return df
    }
}
