//
//  NewsResponseModel.swift
//  SwiftUISharingNewsAppFinal
//
//  Created by Leo Ho on 2026/1/4.
//

/// 新聞回應
struct NewsResponseModel: Codable {
    
    /// 新聞項目列表
    let newsItems: [NewsItem]
    
    /// 錯誤訊息 (如果有的話)
    let errorMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case newsItems = "news_items"
        case errorMessage = "error_message"
    }
}
