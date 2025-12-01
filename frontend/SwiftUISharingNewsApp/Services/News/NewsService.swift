//
//  NewsService.swift
//  SwiftUISharingNewsApp
//
//  Created by Leo Ho on 2025/11/1.
//

import Foundation

/// 定義與後端溝通取得新聞資料的 Protocol
protocol NewsServiceProtocol {
    
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

/// 新聞服務實作類別
final class NewsService: NewsServiceProtocol {
    
    // MARK: - Properties
    
    /// 網路服務實例
    private let networkService: NetworkServiceProtocol
    
    // MARK: - Initializer
    
    /// 初始化
    ///
    /// - Parameters:
    ///   - networkService: 網路服務實例
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    // MARK: - Public Methods
    
    /// 取得所有新聞資料
    ///
    /// - Returns: 新聞資料陣列
    /// - Throws: `NewsServiceError`
    func fetchNews() async throws(NewsServiceError) -> [NewsItem] {
        let requestObject = NewsRequest.default
        do {
            let responseObject: NewsResponse = try await networkService.get(
                stage: .default,
                route: .fetchNews,
                requestObject: requestObject
            )
            
            return responseObject.newsItems
        } catch {
            throw NewsServiceError.networkError(networkError: error)
        }
    }

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
    ) async throws(NewsServiceError) -> [NewsItem] {
        let requestObject = NewsRequest(keyword: keyword, startDate: startDate, endDate: endDate)
        do {
            let responseObject: NewsResponse = try await networkService.post(
                stage: .default,
                route: .searchNews,
                requestObject: requestObject
            )
            
            return responseObject.newsItems
        } catch {
            throw NewsServiceError.networkError(networkError: error)
        }
    }
}
