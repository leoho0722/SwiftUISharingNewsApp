//
//  NewsListViewModel.swift
//  SwiftUISharingNewsAppStarter
//
//  Created by Leo Ho on 2025/11/1.
//

import Foundation
import Observation

/// 新聞列表頁面 ViewModel
@Observable
class NewsListViewModel {
    
    // MARK: - Properties
    
    /// 新聞列表
    private(set) var newsItems: [NewsItem] = []
    
    /// 畫面狀態
    private(set) var viewState: ViewState = .idle
    
    /// 新聞服務實例，透過依賴注入 (DI) 提供
    private let newsService: NewsServiceProtocol
    
    // MARK: - Init
    
    /// 初始化 `NewsListViewModel`
    ///
    /// - Parameter newsService: 新聞服務實例
    init(newsService: NewsServiceProtocol = NewsService()) {
        self.newsService = newsService
    }
}

// MARK: - Nested Types

extension NewsListViewModel {
    
    /// 畫面狀態 enum
    /// 
    /// - idle：閒置 (預設值)
    /// - loading：載入中
    /// - loaded：載入完成
    /// - error：發生失敗
    enum ViewState {
        
        /// 閒置 (預設值)
        case idle
        
        /// 載入中
        case loading
        
        /// 載入完成
        case loaded
        
        /// 發生失敗
        ///
        /// - Parameter error: 發生失敗的錯誤
        case error(Error)
    }
}

// MARK: - Internel Method

extension NewsListViewModel {
    
    /// 抓取所有新聞資料
    func fetchNews() async {
        viewState = .loading
        do {
            let fetchedNews = try await newsService.fetchNews()
            newsItems = fetchedNews
            viewState = .loaded
        } catch {
            viewState = .error(error)
        }
    }
}

// MARK: - UI Sections (供 View 顯示用)

extension NewsListViewModel: NewsGroupable {
    // 使用 NewsGroupable 預設實作
}
