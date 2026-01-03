//
//  MockNewsService.swift
//  SwiftUISharingNewsAppStarterTests
//
//  Created by Leo Ho on 2025/12/5.
//

import Foundation
@testable import SwiftUISharingNewsAppStarter

/// 模擬新聞服務實作，用於單元測試
///
/// 透過設定 `fetchNewsResult` 或 `searchNewsResult` 來控制回傳結果，
/// 並可檢查 `fetchNewsCallCount` 與 `searchNewsCallCount` 來驗證呼叫次數。
final class MockNewsService: NewsServiceProtocol {
    
    // MARK: - Stub Properties
    
    /// 設定 `fetchNews()` 的回傳結果
    var fetchNewsResult: Result<[NewsItem], NewsServiceError> = .success([])
    
    /// 設定 `searchNews()` 的回傳結果
    var searchNewsResult: Result<[NewsItem], NewsServiceError> = .success([])
    
    // MARK: - Call Tracking
    
    /// `fetchNews()` 被呼叫的次數
    private(set) var fetchNewsCallCount = 0
    
    /// `searchNews()` 被呼叫的次數
    private(set) var searchNewsCallCount = 0
    
    /// 最近一次 `searchNews()` 的參數
    private(set) var lastSearchKeyword: String?
    private(set) var lastSearchStartDate: String?
    private(set) var lastSearchEndDate: String?
    
    // MARK: - NewsServiceProtocol
    
    /// 模擬 `fetchNews()` 的行為
    /// 
    /// - Returns: 模擬的 `NewsItem` 陣列
    /// - Throws: 模擬的錯誤
    func fetchNews() async throws(NewsServiceError) -> [NewsItem] {
        fetchNewsCallCount += 1
        switch fetchNewsResult {
        case .success(let items):
            return items
        case .failure(let error):
            throw error
        }
    }
    
    /// 模擬 `searchNews()` 的行為
    /// 
    /// - Parameters:
    ///   - keyword: 模擬的關鍵字
    ///   - startDate: 模擬的開始日期
    ///   - endDate: 模擬的結束日期
    /// - Returns: 模擬的 `NewsItem` 陣列
    /// - Throws: 模擬的錯誤
    func searchNews(
        with keyword: String?,
        startDate: String?,
        endDate: String?
    ) async throws(NewsServiceError) -> [NewsItem] {
        searchNewsCallCount += 1
        lastSearchKeyword = keyword
        lastSearchStartDate = startDate
        lastSearchEndDate = endDate
        
        switch searchNewsResult {
        case .success(let items):
            return items
        case .failure(let error):
            throw error
        }
    }
}
