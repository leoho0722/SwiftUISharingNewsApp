//
//  SearchNewsViewModelTests.swift
//  SwiftUISharingNewsAppStarterTests
//
//  Created by Leo Ho on 2025/12/5.
//

import Testing
import Foundation
@testable import SwiftUISharingNewsAppStarter

/// SearchNewsViewModel 單元測試
///
/// 使用 GWT (Given-When-Then) 風格撰寫，測試新聞搜尋與近期搜尋紀錄管理邏輯。
@Suite("SearchNewsViewModel 測試")
@MainActor
struct SearchNewsViewModelTests {
    
    // MARK: - 初始狀態測試
    
    @Test("給定 ViewModel 剛建立完成，當檢查初始值時，則 viewState 為 idle、inputKeyword 為空、appliedDateFilter 為 nil")
    func initialState_shouldBeIdleWithEmptyConditions() {
        // Given
        let mockService = MockNewsService()
        let viewModel = SearchNewsViewModel(newsService: mockService)
        
        // When & Then
        #expect(viewModel.inputKeyword.isEmpty)
        #expect(viewModel.appliedDateFilter == nil)
        #expect(viewModel.newsItems.isEmpty)
        
        if case .idle = viewModel.viewState {
            // 正確
        }
        else {
            Issue.record("預期 viewState 為 .idle，但實際為 \(viewModel.viewState)")
        }
    }
    
    // MARK: - 搜尋成功測試
    
    @Test("給定 Mock 回傳搜尋結果，當呼叫 performSearch 時，則 viewState 為 loaded 且 newsItems 有資料")
    func performSearch_withSuccess_shouldUpdateToLoadedState() async {
        // Given
        let mockService = MockNewsService()
        let expectedNews = NewsItemFactory.makeList(count: 3)
        mockService.searchNewsResult = .success(expectedNews)
        let viewModel = SearchNewsViewModel(newsService: mockService)
        viewModel.inputKeyword = "測試"
        
        // When
        await viewModel.performSearch()
        
        // Then
        #expect(viewModel.newsItems.count == 3)
        #expect(mockService.searchNewsCallCount == 1)
        #expect(mockService.lastSearchKeyword == "測試")
        
        if case .loaded = viewModel.viewState {
            // 正確
        }
        else {
            Issue.record("預期 viewState 為 .loaded，但實際為 \(viewModel.viewState)")
        }
    }
    
    // MARK: - 搜尋失敗測試
    
    @Test("給定 Mock 拋出錯誤，當呼叫 performSearch 時，則 viewState 為 error")
    func performSearch_withError_shouldUpdateToErrorState() async {
        // Given
        let mockService = MockNewsService()
        let expectedError = NewsServiceError.networkError(networkError: .invalidURL)
        mockService.searchNewsResult = .failure(expectedError)
        let viewModel = SearchNewsViewModel(newsService: mockService)
        
        // When
        await viewModel.performSearch()
        
        // Then
        #expect(viewModel.newsItems.isEmpty)
        
        if case .error = viewModel.viewState {
            // 正確
        }
        else {
            Issue.record("預期 viewState 為 .error，但實際為 \(viewModel.viewState)")
        }
    }
    
    // MARK: - 清除條件測試
    
    @Test("給定已設定 appliedDateFilter，當呼叫 clearDateFilters 時，則 appliedDateFilter 為 nil")
    func clearDateFilters_shouldSetAppliedDateFilterToNil() {
        // Given
        let mockService = MockNewsService()
        let viewModel = SearchNewsViewModel(newsService: mockService)
        viewModel.appliedDateFilter = .defaultRange
        
        // When
        viewModel.clearDateFilters()
        
        // Then
        #expect(viewModel.appliedDateFilter == nil)
    }
    
    @Test("給定已設定關鍵字與日期，當呼叫 clearAllConditions 時，則所有條件被清除")
    func clearAllConditions_shouldClearAllSearchConditions() {
        // Given
        let mockService = MockNewsService()
        let viewModel = SearchNewsViewModel(newsService: mockService)
        viewModel.inputKeyword = "測試"
        viewModel.appliedDateFilter = .defaultRange
        
        // When
        viewModel.clearAllConditions()
        
        // Then
        #expect(viewModel.inputKeyword.isEmpty)
        #expect(viewModel.appliedDateFilter == nil)
    }
    
    // MARK: - 空白關鍵字處理測試
    
    @Test("給定輸入的關鍵字只有空白，當呼叫 performSearch 時，則搜尋參數中的 keyword 為 nil")
    func performSearch_withWhitespaceKeyword_shouldNormalizeToNil() async {
        // Given
        let mockService = MockNewsService()
        mockService.searchNewsResult = .success([])
        let viewModel = SearchNewsViewModel(newsService: mockService)
        viewModel.inputKeyword = "   "
        
        // When
        await viewModel.performSearch()
        
        // Then
        #expect(mockService.lastSearchKeyword == nil)
    }
}
