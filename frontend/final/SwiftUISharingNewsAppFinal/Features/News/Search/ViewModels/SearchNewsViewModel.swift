//
//  SearchNewsViewModel.swift
//  SwiftUISharingNewsAppFinal
//
//  Created by Leo Ho on 2025/11/4.
//

import Foundation



/// 新聞搜尋頁面 ViewModel
@Observable
class SearchNewsViewModel {
    
    // MARK: - Properties
    
    /// 新聞列表
    private(set) var newsItems: [NewsItem] = []
    
    /// 畫面狀態
    private(set) var viewState: ViewState = .idle
    
    /// 輸入的新聞關鍵字
    var inputKeyword = ""
    
    /// 已套用的日期篩選條件
    var appliedDateFilter: DateFilter?
    
    /// 新聞服務實例，透過依賴注入 (DI) 提供
    private let newsService: NewsServiceProtocol
    
    /// 資料庫 Repository
    private var repository: RecentSearchRepositoryProtocol?
    
    // MARK: - Initializer
    
    /// 初始化
    ///
    /// - Parameters:
    ///   - newsService: 新聞服務實例
    init(newsService: NewsServiceProtocol = NewsService()) {
        self.newsService = newsService
    }
    
    // MARK: - Public Methods
    
    /// 設定 Repository
    ///
    /// - Parameters:
    ///   - repository: RecentSearchRepositoryProtocol 實作
    func configure(repository: RecentSearchRepositoryProtocol) {
        self.repository = repository
    }
    
    /// 執行搜尋請求並視需求儲存成近期搜尋紀錄
    ///
    /// - Parameters:
    ///   - saveToRecents: 是否需將此次搜尋條件寫入近期搜尋快取，預設值為 true
    @MainActor
    func performSearch(saveToRecents: Bool = true) async {
        let keyword = inputKeyword.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedKeyword = keyword.isEmpty ? nil : keyword
        let startDate = appliedDateFilter?.startDate
        let endDate = appliedDateFilter?.endDate
        
        viewState = .loading
        
        do {
            let searchedNews = try await newsService.searchNews(
                with: normalizedKeyword,
                startDate: startDate.map { $0.formatted(.backend) },
                endDate: endDate.map { $0.formatted(.backend) }
            )
            newsItems = searchedNews
            viewState = .loaded
            
            if saveToRecents {
                try repository?.saveSearch(
                    keyword: normalizedKeyword,
                    startDate: startDate,
                    endDate: endDate
                )
            }
        } catch {
            viewState = .error(error)
        }
    }
    
    /// 將選擇的近期搜尋套用到頁面狀態
    ///
    /// - Parameters:
    ///   - search: 選擇的近期搜尋紀錄
    func applyRecentSearch(_ search: RecentSearch) {
        inputKeyword = search.keyword ?? ""
        
        if let startDate = search.startDate, let endDate = search.endDate {
            appliedDateFilter = DateFilter(startDate: startDate, endDate: endDate)
        }
        else {
            appliedDateFilter = nil
        }
    }
    
    /// 清除目前的日期篩選設定
    func clearDateFilters() {
        appliedDateFilter = nil
    }
    
    /// 同時清除關鍵字與日期條件
    func clearAllConditions() {
        inputKeyword = ""
        clearDateFilters()
    }
    
    // MARK: - Repository Logic
    
    /// 刪除單筆近期搜尋
    ///
    /// - Parameters:
    ///   - search: 需要刪除的近期搜尋紀錄
    @MainActor
    func removeRecentSearch(_ search: RecentSearch) {
        do {
            try repository?.deleteSearch(search)
        } catch {
            viewState = .error(error)
        }
    }
    
    /// 刪除所有近期搜尋
    ///
    /// - Parameters:
    ///   - searches: 需要刪除的近期搜尋紀錄
    @MainActor
    func removeAllRecentSearches(searches: [RecentSearch]) {
        do {
            try repository?.deleteAllSearches(searches)
        } catch {
            viewState = .error(error)
        }
    }
    
    /// 清除已過期的近期搜尋紀錄
    @MainActor
    func purgeExpiredRecentSearches() async {
        do {
            try await repository?.purgeExpiredSearches()
        } catch {
            viewState = .error(error)
        }
    }
}

// MARK: - Nested Types

extension SearchNewsViewModel {
    
    /// 畫面狀態 enum
    enum ViewState {
        
        /// 閒置 (預設值)
        case idle
        
        /// 載入中
        case loading
        
        /// 載入完成
        case loaded
        
        /// 發生錯誤
        ///
        /// - Parameters:
        ///   - error: 發生的錯誤
        case error(Error)
    }
    
    /// 日期篩選條件的封裝模型
    struct DateFilter: Equatable {
        
        /// 開始日期
        var startDate: Date
        
        /// 結束日期
        var endDate: Date
        
        /// 預設值 (最近一周)
        static var defaultRange: DateFilter {
            let now = Date()
            let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: now) ?? now
            return DateFilter(startDate: weekAgo, endDate: now)
        }
    }
}

// MARK: - UI Sections (供 View 顯示用)

extension SearchNewsViewModel: NewsGroupable {
    
    /// 覆寫預設實作，改成日期由舊到新排序
    var groupedSections: [NewsSection] {
        groupNewsByDate(newsItems, sortOrder: .descending)
    }
}
