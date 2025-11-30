//
//  SearchNewsView.swift
//  SwiftUISharingNewsApp
//
//  Created by Leo Ho on 2025/11/4.
//

import SwiftUI
import SwiftData

/// 新聞搜尋頁面
struct SearchNewsView: View {
    
    // MARK: - View Properties
    
    /// 新聞搜尋頁面的 ViewModel
    @State private var viewModel = SearchNewsViewModel()
    
    /// 篩選面板中的臨時日期範圍
    @State private var draftDateFilter: SearchNewsViewModel.DateFilter = .defaultRange
    
    /// 是否顯示篩選面板
    @State private var isFilterSheetPresented: Bool = false
    
    /// SwiftData ModelContext
    @Environment(\.modelContext) private var modelContext
    
    /// 透過 SwiftData 查詢出的最近搜尋資料
    @Query(sort: \RecentSearch.createdAt, order: .reverse)
    private var recentSearches: [RecentSearch]
    
    // MARK: - View Body
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("搜尋新聞")
                .toolbar {
                    toolbarContent
                }
                .sheet(isPresented: $isFilterSheetPresented) {
                    filterSheet
                }
        }
        .searchable(
            text: $viewModel.inputKeyword,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "請輸入新聞關鍵字"
        )
        .searchSuggestions { recentSearchSuggestions }
        .onSubmit(of: .search) {
            await viewModel.performSearch()
        }
        .task {
            // 設定 Repository 到 ViewModel
            let repository = RecentSearchRepository(modelContext: modelContext)
            viewModel.configure(repository: repository)
            
            // 清除過期的近期搜尋紀錄
            await viewModel.purgeExpiredRecentSearches()
        }
    }
}

// MARK: - ViewBuilder

private extension SearchNewsView {
    
    /// 依據不同狀態顯示的主內容
    @ViewBuilder
    var content: some View {
        Group {
            switch viewModel.viewState {
            case .idle:
                idleStateView
            case .loading:
                LoadingView("搜尋新聞中...")
            case .loaded:
                if viewModel.groupedSections.isEmpty {
                    emptyStateView
                } else {
                    resultsList
                }
            case .error(let error):
                errorStateView(error)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemGroupedBackground))
    }
    
    @ViewBuilder
    var idleStateView: some View {
        ContentUnavailableView {
            Label("開始搜尋新聞", symbols: .magnifyingglass)
        } description: {
            Text("輸入關鍵字或設定日期篩選，然後點擊搜尋。")
        }
    }
    
    @ViewBuilder
    var emptyStateView: some View {
        ContentUnavailableView {
            Label("找不到符合的新聞", symbols: .newspaperFill)
        } description: {
            Text("請調整關鍵字或篩選條件後再試一次。")
        } actions: {
            Button {
                viewModel.clearAllConditions()
            } label: {
                Label("清除條件", symbols: .xmarkCircleFill)
            }
        }
    }
    
    @ViewBuilder
    var resultsList: some View {
        List {
            ForEach(viewModel.groupedSections) { section in
                Section(section.sectionTitle) {
                    ForEach(section.items) { newsItem in
                        NavigationLink {
                            NewsDetailView(newsItem: newsItem)
                        } label: {
                            Text(newsItem.title)
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }
    
    /// 根據錯誤狀態呈現錯誤畫面與重試動作。
    ///
    /// - Parameters:
    ///   - error: 透過 ViewModel 回傳的錯誤。
    /// - Returns: 包含錯誤訊息與重試按鈕的視圖。
    @ViewBuilder
    func errorStateView(_ error: any Error) -> some View {
        ErrorView {
            Label("搜尋失敗", symbols: .exclamationmarkTriangleFill)
        } description: {
            Text(error.localizedDescription)
        } actions: {
            AsyncButton {
                await viewModel.performSearch()
            } label: {
                Label("重新嘗試", symbols: .arrowCounterclockwise)
            }
            .padding(.top, 8)
        }
    }
    
    @ToolbarContentBuilder
    var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            Button {
                draftDateFilter = viewModel.appliedDateFilter ?? .defaultRange
                isFilterSheetPresented = true
            } label: {
                Label(filterToolbarTitle, symbols: .line3HorizontalDecreaseCircle)
            }
            .accessibilityLabel("調整篩選條件")
            .tint(viewModel.appliedDateFilter == nil ? .primary : .accentColor)
            
            AsyncButton {
                await viewModel.performSearch()
            } label: {
                Label("搜尋", symbols: .magnifyingglass)
            }
            .keyboardShortcut(.defaultAction)
        }
    }
    
    @ViewBuilder
    var recentSearchSuggestions: some View {
        // 這裡簡單過濾，或可呼叫 ViewModel 的 helper
        let cutoff = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? .distantPast
        let suggestions = recentSearches.filter { $0.createdAt >= cutoff }
        
        if suggestions.isEmpty { 
            EmptyView()
        }
        else {
            Section("近期搜尋") {
                ForEach(suggestions) { search in
                    AsyncButton {
                        viewModel.applyRecentSearch(search)
                        await viewModel.performSearch(saveToRecents: false)
                    } label: {
                        Label(recentSearchTitle(for: search), symbols: .clock)
                    }
                    .contextMenu {
                        Button(role: .destructive) {
                            viewModel.removeRecentSearch(search)
                        } label: {
                            Label("刪除此紀錄", symbols: .trash)
                        }
                    }
                }
                Button(role: .destructive) {
                    viewModel.removeAllRecentSearches(searches: recentSearches)
                } label: {
                    Label("清除全部", symbols: .trash)
                }
            }
        }
    }
    
    @ViewBuilder
    var filterSheet: some View {
        NavigationStack {
            Form {
                Section("日期篩選") {
                    DatePicker(
                        "開始日期",
                        selection: $draftDateFilter.startDate,
                        displayedComponents: .date
                    )
                    DatePicker(
                        "結束日期",
                        selection: $draftDateFilter.endDate,
                        displayedComponents: .date
                    )
                    
                    if draftDateFilter.startDate > draftDateFilter.endDate {
                        Text("開始日期不可晚於結束日期")
                            .font(.footnote)
                            .foregroundStyle(.red)
                    }
                }
            }
            .environment(\.locale, userPreferredLocale)
            .navigationTitle("篩選條件")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        restoreDraftDateFilter()
                        isFilterSheetPresented = false
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button("重設篩選") {
                        viewModel.clearDateFilters()
                        restoreDraftDateFilter()
                        isFilterSheetPresented = false
                    }
                    .tint(.red)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("套用") {
                        guard draftDateFilter.startDate <= draftDateFilter.endDate else {
                            return
                        }
                        viewModel.appliedDateFilter = draftDateFilter
                        isFilterSheetPresented = false
                    }
                    .disabled(draftDateFilter.startDate > draftDateFilter.endDate)
                }
            }
        }
        .presentationDetents([.medium])
    }
}

// MARK: - Preview

#Preview {
    SearchNewsView()
        .modelContainer(for: RecentSearch.self, inMemory: true)
}

// MARK: - Private Helpers

private extension SearchNewsView {
    
    /// 依據已套用的日期條件產生工具列標題文字。
    var filterToolbarTitle: String {
        guard let appliedDateFilter = viewModel.appliedDateFilter else {
            return "不限日期"
        }
        
        let startDateFormatted = appliedDateFilter.startDate.formatted(.display)
        let endDateFormatted = appliedDateFilter.endDate.formatted(.display)
        
        return "篩選：\(startDateFormatted) - \(endDateFormatted)"
    }
    
    /// 使用者偏好的語系（依系統語言自動更新）。
    var userPreferredLocale: Locale {
        Locale.autoupdatingCurrent
    }
    
    /// 依據關鍵字或日期組合，生成顯示在建議列的標題。
    ///
    /// - Parameters:
    ///   - search: 準備顯示的近期搜尋紀錄。
    /// - Returns: 顯示於搜尋建議的標題文字。
    func recentSearchTitle(for search: RecentSearch) -> String {
        if let keyword = search.keyword, !keyword.isEmpty {
            return keyword
        }
        
        if let startDate = search.startDate, let endDate = search.endDate {
            let startDateFormatted = startDate.formatted(.display)
            let endDateFormatted = endDate.formatted(.display)
            
            return "\(startDateFormatted) - \(endDateFormatted)"
        }
        return "未命名搜尋"
    }
    
    /// 將編輯中的暫存日期恢復為目前已套用的狀態。
    func restoreDraftDateFilter() {
        draftDateFilter = viewModel.appliedDateFilter ?? .defaultRange
    }
}
