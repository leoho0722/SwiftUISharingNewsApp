//
//  NewsRequest.swift
//  SwiftUISharingNewsApp
//
//  Created by Leo Ho on 2025/11/1.
//

import Foundation

/// 新聞請求
struct NewsRequest: Codable {
    
    /// 關鍵字
    let keyword: String?
    
    /// 開始日期
    let startDate: String?
    
    /// 結束日期
    let endDate: String?
    
    enum CodingKeys: String, CodingKey {
        case keyword
        case startDate = "start_date"
        case endDate = "end_date"
    }
    
    /// 預設請求方式，即取得所有新聞資料
    static let `default`: Self = NewsRequest(keyword: nil, startDate: nil, endDate: nil)
}

/// 新聞回應
struct NewsResponse: Codable {
    
    /// 新聞項目列表
    let newsItems: [NewsItem]
    
    /// 錯誤訊息 (如果有的話)
    let errorMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case newsItems = "news_items"
        case errorMessage = "error_message"
    }
}
