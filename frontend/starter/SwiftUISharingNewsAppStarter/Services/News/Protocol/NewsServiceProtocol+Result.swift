//
//  NewsServiceProtocol+Result.swift
//  SwiftUISharingNewsAppStarter
//
//  Created by Leo Ho on 2026/1/4.
//

import Foundation

/// 定義使用 Result 與後端溝通取得新聞資料的 Protocol
protocol NewsServiceResultProtocol {
    
    /// 取得所有新聞資料
    ///
    /// - Parameter completion: 請求完成時的要做的事
    func fetchNews(completion: @escaping (Result<[NewsItem], NewsServiceError>) -> Void)
    
    /// 根據條件 (關鍵字、開始日期、結束日期) 搜尋新聞資料
    ///
    /// - Parameters:
    ///   - keyword: 關鍵字
    ///   - startDate: 開始日期
    ///   - endDate: 結束日期
    ///   - completion: 請求完成時的要做的事
    func searchNews(
        with keyword: String?,
        startDate: String?,
        endDate: String?,
        completion: @escaping (Result<[NewsItem], NewsServiceError>) -> Void
    )
}
