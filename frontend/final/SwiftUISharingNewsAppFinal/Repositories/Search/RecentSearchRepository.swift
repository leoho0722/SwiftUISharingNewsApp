//
//  RecentSearchRepository.swift
//  SwiftUISharingNewsAppFinal
//
//  Created by Leo Ho on 2025/11/30.
//

import Foundation
import SwiftData

/// 近期搜尋紀錄 Repository Protocol
@MainActor
protocol RecentSearchRepositoryProtocol {
    
    /// 取得所有近期搜尋紀錄
    ///
    /// - Returns: 近期搜尋紀錄陣列
    func fetchRecentSearches() throws -> [RecentSearch]
    
    /// 儲存或更新近期搜尋紀錄
    ///
    /// - Parameters:
    ///   - keyword: 關鍵字
    ///   - startDate: 開始日期
    ///   - endDate: 結束日期
    func saveSearch(keyword: String?, startDate: Date?, endDate: Date?) throws
    
    /// 刪除單筆近期搜尋紀錄
    ///
    /// - Parameters:
    ///   - search: 要刪除的紀錄
    func deleteSearch(_ search: RecentSearch) throws
    
    /// 刪除多筆近期搜尋紀錄
    ///
    /// - Parameters:
    ///   - searches: 要刪除的紀錄陣列
    func deleteAllSearches(_ searches: [RecentSearch]) throws
    
    /// 清除過期的近期搜尋紀錄 (超過 7 天)
    func purgeExpiredSearches() async throws
}

/// 近期搜尋紀錄 Repository 實作
@MainActor
final class RecentSearchRepository: RecentSearchRepositoryProtocol {
    
    /// SwiftData ModelContext
    private let modelContext: ModelContext
    
    /// 初始化 `RecentSearchRepository`
    ///
    /// - Parameter modelContext: SwiftData ModelContext
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    /// 取得所有近期搜尋紀錄
    ///
    /// - Returns: 近期搜尋紀錄陣列
    func fetchRecentSearches() throws -> [RecentSearch] {
        let descriptor = FetchDescriptor<RecentSearch>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }
    
    /// 儲存或更新近期搜尋紀錄
    ///
    /// - Parameters:
    ///   - keyword: 關鍵字
    ///   - startDate: 開始日期
    ///   - endDate: 結束日期
    func saveSearch(keyword: String?, startDate: Date?, endDate: Date?) throws {
        let conditions: [Any?] = [keyword, startDate, endDate]
        guard !conditions.compactMap({ $0 }).isEmpty else {
            return
        }   
        
        // 檢查是否已存在相同的搜尋條件
        let descriptor = FetchDescriptor<RecentSearch>()
        let allSearches = try modelContext.fetch(descriptor)
        
        let firstSearch = allSearches.first(where: {
            $0.keyword == keyword &&
            $0.startDate == startDate &&
            $0.endDate == endDate
        })
        
        if let existing = firstSearch {
            existing.update(
                keyword: keyword,
                startDate: startDate,
                endDate: endDate
            )
        }
        else {
            let search = RecentSearch(
                keyword: keyword,
                startDate: startDate,
                endDate: endDate
            )
            modelContext.insert(search)
        }
        
        try modelContext.save()
    }
    
    /// 刪除單筆近期搜尋紀錄
    ///
    /// - Parameter search: 要刪除的紀錄
    func deleteSearch(_ search: RecentSearch) throws {
        modelContext.delete(search)
        try modelContext.save()
    }
    
    /// 刪除多筆近期搜尋紀錄
    ///
    /// - Parameter searches: 要刪除的紀錄陣列
    func deleteAllSearches(_ searches: [RecentSearch]) throws {
        searches.forEach { modelContext.delete($0) }
        try modelContext.save()
    }
    
    /// 清除過期的近期搜尋紀錄 (超過 7 天)
    func purgeExpiredSearches() async throws {
        // 截止時間點
        let cutoff = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? .distantPast

        try modelContext.delete(
            model: RecentSearch.self,
            where: #Predicate { $0.createdAt < cutoff }
        )
    }
}
