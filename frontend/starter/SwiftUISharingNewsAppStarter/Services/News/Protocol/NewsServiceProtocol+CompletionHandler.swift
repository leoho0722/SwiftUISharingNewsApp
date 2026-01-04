//
//  NewsServiceProtocol+CompletionHandler.swift
//  SwiftUISharingNewsAppStarter
//
//  Created by Leo Ho on 2026/1/4.
//

import Foundation

/// 定義使用 Completion Handler 與後端溝通取得新聞資料的 Protocol
protocol NewsServiceCompletionHandlerProtocol {
    
    /// 取得所有新聞資料
    ///
    /// - Parameters:
    ///   - success: 請求成功時的要做的事
    ///   - failure: 請求失敗時的要做的事
    func fetchNews(
        success: @escaping ([NewsItem]) -> Void,
        failure: @escaping (NewsServiceError) -> Void
    )
    
    /// 根據條件 (關鍵字、開始日期、結束日期) 搜尋新聞資料
    ///
    /// - Parameters:
    ///   - keyword: 關鍵字
    ///   - startDate: 開始日期
    ///   - endDate: 結束日期
    ///   - success: 請求成功時的要做的事
    ///   - failure: 請求失敗時的要做的事
    func searchNews(
        with keyword: String?,
        startDate: String?,
        endDate: String?,
        success: @escaping ([NewsItem]) -> Void,
        failure: @escaping (NewsServiceError) -> Void
    )
}
