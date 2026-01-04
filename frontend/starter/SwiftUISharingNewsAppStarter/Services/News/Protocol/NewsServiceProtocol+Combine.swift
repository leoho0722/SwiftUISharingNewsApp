//
//  NewsServiceProtocol+Combine.swift
//  SwiftUISharingNewsAppStarter
//
//  Created by Leo Ho on 2026/1/4.
//

import Combine
import Foundation

/// 定義使用 Combine 與後端溝通取得新聞資料的 Protocol
protocol NewsServiceCombineProtocol {
    
    /// 取得所有新聞資料
    ///
    /// - Returns: AnyPublisher 物件
    func fetchNews() -> AnyPublisher<[NewsItem], NewsServiceError>
    
    /// 根據條件 (關鍵字、開始日期、結束日期) 搜尋新聞資料
    ///
    /// - Parameters:
    ///   - keyword: 關鍵字
    ///   - startDate: 開始日期
    ///   - endDate: 結束日期
    /// - Returns: AnyPublisher 物件
    func searchNews(
        with keyword: String?,
        startDate: String?,
        endDate: String?
    ) -> AnyPublisher<[NewsItem], NewsServiceError>
}
