//
//  NewsListViewModel.swift
//  SwiftUISharingNewsApp
//
//  Created by Leo Ho on 2025/11/1.
//

import Foundation

@Observable
class NewsListViewModel {
    
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

extension NewsListViewModel {
    
    /// 提供給 UI 的分組後 Section，依日期由新到舊排序
    var groupedSections: [NewsSection] {
        let calendar = Calendar(identifier: .gregorian)
        
        // 轉為 (normalizedDate, item)
        let pairs: [(Date, NewsItem)] = newsItems.compactMap { item in
            guard let date = backendDateFormatter.date(from: item.publishDate) else {
                return nil
            }
            // 以本地時區取年月日，建立不含時間的日期
            let comps = calendar.dateComponents(in: .current, from: date)
            let normalizedComponents = DateComponents(
                calendar: calendar,
                timeZone: .current,
                year: comps.year,
                month: comps.month,
                day: comps.day
            )
            guard let dayDate = calendar.date(from: normalizedComponents) else {
                return nil
            }
            return (dayDate, item)
        }
        
        // 分組
        let grouped = Dictionary(grouping: pairs, by: { $0.0 }).mapValues { $0.map { $0.1 } }
        
        // 產生 Section 並排序（由新到舊）
        let sections: [NewsSection] = grouped
            .map { date, items in
                NewsSection(
                    id: date,
                    sectionTitle: displayDateFormatter.string(from: date),
                    items: items
                )
            }
            .sorted(by: { $0.id > $1.id })
        
        return sections
    }
}

// MARK: - Date Formatters

private extension NewsListViewModel {
    
    /// 解析後端回傳的日期字串（例如 "2025-01-22"）
    var backendDateFormatter: DateFormatter {
        let df = DateFormatter()
        df.calendar = Calendar(identifier: .gregorian)
        df.locale = Locale(identifier: "zh_TW")
        df.timeZone = TimeZone(secondsFromGMT: 0)
        df.dateFormat = "yyyy-MM-dd"
        return df
    }
    
    /// 顯示在 Section Header 的日期格式
    var displayDateFormatter: DateFormatter {
        let df = DateFormatter()
        df.calendar = Calendar(identifier: .gregorian)
        df.locale = Locale(identifier: "zh_TW")
        df.timeZone = .current
        df.dateFormat = "yyyy/MM/dd"
        return df
    }
}

// MARK: - Nested Types

extension NewsListViewModel {
    
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
    
    /// UI 使用的 Section 模型（同一發布日期的新聞群組）
    struct NewsSection: Identifiable {
        
        /// 以「去除時間的日期」作為識別
        let id: Date
        
        /// 顯示在 Section Header 的字串（已格式化）
        let sectionTitle: String
        
        /// 同日的新聞項目
        let items: [NewsItem]
    }
}
