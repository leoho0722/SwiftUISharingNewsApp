//
//  MockRecentSearchRepository.swift
//  SwiftUISharingNewsAppFinalTests
//
//  Created by Leo Ho on 2025/12/5.
//

import Foundation
@testable import SwiftUISharingNewsAppFinal

/// 模擬近期搜尋 Repository 實作，用於單元測試
///
/// 透過設定各方法的結果來控制行為，並可檢查呼叫紀錄來驗證操作。
@MainActor
final class MockRecentSearchRepository: RecentSearchRepositoryProtocol {
    
    // MARK: - Stub Properties
    
    /// 設定 `fetchRecentSearches()` 的回傳結果
    var fetchRecentSearchesResult: Result<[RecentSearch], Error> = .success([])
    
    /// 設定 `saveSearch()` 是否拋出錯誤
    var saveSearchError: Error?
    
    /// 設定 `deleteSearch()` 是否拋出錯誤
    var deleteSearchError: Error?
    
    /// 設定 `deleteAllSearches()` 是否拋出錯誤
    var deleteAllSearchesError: Error?
    
    /// 設定 `purgeExpiredSearches()` 是否拋出錯誤
    var purgeExpiredSearchesError: Error?
    
    // MARK: - Call Tracking
    
    /// `saveSearch()` 被呼叫的次數
    private(set) var saveSearchCallCount = 0
    
    /// 最近一次 `saveSearch()` 的參數
    private(set) var lastSavedKeyword: String?
    private(set) var lastSavedStartDate: Date?
    private(set) var lastSavedEndDate: Date?
    
    /// `deleteSearch()` 被呼叫的次數
    private(set) var deleteSearchCallCount = 0
    
    /// 最近一次 `deleteSearch()` 的參數
    private(set) var lastDeletedSearch: RecentSearch?
    
    /// `deleteAllSearches()` 被呼叫的次數
    private(set) var deleteAllSearchesCallCount = 0
    
    /// 最近一次 `deleteAllSearches()` 的參數
    private(set) var lastDeletedSearches: [RecentSearch]?
    
    /// `purgeExpiredSearches()` 被呼叫的次數
    private(set) var purgeExpiredSearchesCallCount = 0
    
    // MARK: - RecentSearchRepositoryProtocol
    
    /// 模擬 `fetchRecentSearches()` 的行為
    /// 
    /// - Returns: 模擬的 `RecentSearch` 陣列
    /// - Throws: 模擬的錯誤
    func fetchRecentSearches() throws -> [RecentSearch] {
        switch fetchRecentSearchesResult {
        case .success(let searches):
            return searches
        case .failure(let error):
            throw error
        }
    }
    
    /// 模擬 `saveSearch()` 的行為
    /// 
    /// - Parameters:
    ///   - keyword: 模擬的關鍵字
    ///   - startDate: 模擬的開始日期
    ///   - endDate: 模擬的結束日期
    /// - Throws: 模擬的錯誤
    func saveSearch(keyword: String?, startDate: Date?, endDate: Date?) throws {
        saveSearchCallCount += 1
        lastSavedKeyword = keyword
        lastSavedStartDate = startDate
        lastSavedEndDate = endDate
        
        if let error = saveSearchError {
            throw error
        }
    }
    
    /// 模擬 `deleteSearch()` 的行為
    /// 
    /// - Parameters:
    ///   - search: 模擬的 `RecentSearch` 實例
    /// - Throws: 模擬的錯誤
    func deleteSearch(_ search: RecentSearch) throws {
        deleteSearchCallCount += 1
        lastDeletedSearch = search
        
        if let error = deleteSearchError {
            throw error
        }
    }
    
    /// 模擬 `deleteAllSearches()` 的行為
    /// 
    /// - Parameters:
    ///   - searches: 模擬的 `RecentSearch` 陣列
    /// - Throws: 模擬的錯誤
    func deleteAllSearches(_ searches: [RecentSearch]) throws {
        deleteAllSearchesCallCount += 1
        lastDeletedSearches = searches
        
        if let error = deleteAllSearchesError {
            throw error
        }
    }
    
    /// 模擬 `purgeExpiredSearches()` 的行為
    /// 
    /// - Throws: 模擬的錯誤
    func purgeExpiredSearches() async throws {
        purgeExpiredSearchesCallCount += 1
        
        if let error = purgeExpiredSearchesError {
            throw error
        }
    }
}
