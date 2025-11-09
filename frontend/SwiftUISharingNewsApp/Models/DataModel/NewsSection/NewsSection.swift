//
//  NewsSection.swift
//  SwiftUISharingNewsApp
//
//  Created by Leo Ho on 2025/11/4.
//

import Foundation

/// UI 使用的 Section 模型(同一發布日期的新聞群組)
struct NewsSection: Identifiable {
    
    /// 以「去除時間的日期」作為識別
    let id: Date
    
    /// 顯示在 Section Header 的字串(已格式化)
    let sectionTitle: String
    
    /// 同日的新聞項目
    let items: [NewsItem]
}