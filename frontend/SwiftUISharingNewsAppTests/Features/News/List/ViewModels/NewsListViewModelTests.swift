//
//  NewsListViewModelTests.swift
//  SwiftUISharingNewsAppTests
//
//  Created by Leo Ho on 2025/12/5.
//

import Testing
@testable import SwiftUISharingNewsApp

/// NewsListViewModel 單元測試
///
/// 使用 GWT (Given-When-Then) 風格撰寫，測試新聞列表的抓取與狀態管理邏輯。
@Suite("NewsListViewModel 測試")
struct NewsListViewModelTests {
    
    // MARK: - 初始狀態測試
    
    @Test("給定 ViewModel 剛建立完成，當檢查初始值時，則 viewState 為 idle 且 newsItems 為空")
    func initialState_shouldBeIdleWithEmptyItems() {
        // Given
        let mockService = MockNewsService()
        let viewModel = NewsListViewModel(newsService: mockService)
        
        // When & Then
        #expect(viewModel.newsItems.isEmpty)
        
        if case .idle = viewModel.viewState {
            // 正確
        } else {
            Issue.record("預期 viewState 為 .idle，但實際為 \(viewModel.viewState)")
        }
    }
    
    // MARK: - 抓取成功測試
    
    @Test("給定 Mock 回傳新聞資料，當呼叫 fetchNews 時，則 viewState 為 loaded 且 newsItems 有資料")
    func fetchNews_withSuccess_shouldUpdateToLoadedState() async {
        // Given
        let mockService = MockNewsService()
        let expectedNews = NewsItemFactory.makeList(count: 3)
        mockService.fetchNewsResult = .success(expectedNews)
        let viewModel = NewsListViewModel(newsService: mockService)
        
        // When
        await viewModel.fetchNews()
        
        // Then
        #expect(viewModel.newsItems.count == 3)
        #expect(mockService.fetchNewsCallCount == 1)
        
        if case .loaded = viewModel.viewState {
            // 正確
        } else {
            Issue.record("預期 viewState 為 .loaded，但實際為 \(viewModel.viewState)")
        }
    }
    
    // MARK: - 抓取失敗測試
    
    @Test("給定 Mock 拋出錯誤，當呼叫 fetchNews 時，則 viewState 為 error 且包含正確錯誤")
    func fetchNews_withError_shouldUpdateToErrorState() async {
        // Given
        let mockService = MockNewsService()
        let expectedError = NewsServiceError.networkError(
            networkError: .invalidURL
        )
        mockService.fetchNewsResult = .failure(expectedError)
        let viewModel = NewsListViewModel(newsService: mockService)
        
        // When
        await viewModel.fetchNews()
        
        // Then
        #expect(viewModel.newsItems.isEmpty)
        #expect(mockService.fetchNewsCallCount == 1)
        
        if case .error = viewModel.viewState {
            // 正確
        } else {
            Issue.record("預期 viewState 為 .error，但實際為 \(viewModel.viewState)")
        }
    }
    
    // MARK: - 多次抓取測試
    
    @Test("給定已抓取過資料，當再次呼叫 fetchNews 時，則資料會被更新")
    func fetchNews_calledMultipleTimes_shouldUpdateData() async {
        // Given
        let mockService = MockNewsService()
        let firstBatch = NewsItemFactory.makeList(count: 2)
        let secondBatch = NewsItemFactory.makeList(count: 5)
        mockService.fetchNewsResult = .success(firstBatch)
        let viewModel = NewsListViewModel(newsService: mockService)
        
        // When - 第一次抓取
        await viewModel.fetchNews()
        #expect(viewModel.newsItems.count == 2)
        
        // When - 第二次抓取
        mockService.fetchNewsResult = .success(secondBatch)
        await viewModel.fetchNews()
        
        // Then
        #expect(viewModel.newsItems.count == 5)
        #expect(mockService.fetchNewsCallCount == 2)
    }
}
