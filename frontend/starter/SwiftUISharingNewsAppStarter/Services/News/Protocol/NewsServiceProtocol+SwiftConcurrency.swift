//
//  NewsServiceProtocol+SwiftConcurrency.swift
//  SwiftUISharingNewsAppStarter
//
//  Created by Leo Ho on 2026/1/4.
//

import Foundation

/// 定義使用 Swift Concurrency 與後端溝通取得新聞資料的 Protocol
protocol NewsServiceSwiftConcurrencyProtocol {
    
    /// 取得所有新聞資料
    ///
    /// - Returns: 新聞資料陣列
    /// - Throws: `NewsServiceError`
    func fetchNews() async throws(NewsServiceError) -> [NewsItem]
    
    /// 根據條件 (關鍵字、開始日期、結束日期) 搜尋新聞資料
    ///
    /// - Parameters:
    ///   - keyword: 關鍵字
    ///   - startDate: 開始日期
    ///   - endDate: 結束日期
    /// - Returns: 符合條件的新聞資料陣列
    /// - Throws: `NewsServiceError`
    func searchNews(
        with keyword: String?,
        startDate: String?,
        endDate: String?
    ) async throws(NewsServiceError) -> [NewsItem]
}
