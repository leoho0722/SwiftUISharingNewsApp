//
//  SearchNewsViewModel.swift
//  SwiftUISharingNewsApp
//
//  Created by Leo Ho on 2025/11/4.
//

import Foundation

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
        
        /// 載入失敗
        ///
        /// - Parameters:
        ///   - error: 載入失敗的錯誤
        case error(Error)
    }
}

/// 新聞搜尋頁面 ViewModel
@Observable
class SearchNewsViewModel {
    
    // MARK: - Properties
    
    /// 新聞列表
    private(set) var newsItems: [NewsItem] = []
    
    /// 畫面狀態
    private(set) var viewState: ViewState = .idle
    
    /// 新聞服務實例，透過依賴注入 (DI) 提供
    private let newsService: NewsServiceProtocol
    
    // MARK: - Initializer
    
    /// 初始化
    ///
    /// - Parameters:
    ///   - newsService: 新聞服務實例
    init(newsService: NewsServiceProtocol = NewsService()) {
        self.newsService = newsService
    }
    
    // MARK: - Public Methods
    
    /// 根據條件 (關鍵字、開始日期、結束日期) 搜尋新聞資料
    ///
    /// - Parameters:
    ///   - keyword: 關鍵字
    ///   - startDate: 開始日期
    ///   - endDate: 結束日期
    func searchNews(with keyword: String?, startDate: String?, endDate: String?) async {
        viewState = .loading
        do {
            let searchedNews = try await newsService.searchNews(
                with: keyword,
                startDate: startDate,
                endDate: endDate
            )
            newsItems = searchedNews
            viewState = .loaded
        } catch {
            viewState = .error(error)
        }
    }
}

// MARK: - UI Sections (供 View 顯示用)

extension SearchNewsViewModel: NewsGroupable {
    
    /// 覆寫預設實作，改成日期由舊到新排序
    var groupedSections: [NewsSection] {
        groupNewsByDate(newsItems, sortOrder: .ascending)
    }
}
