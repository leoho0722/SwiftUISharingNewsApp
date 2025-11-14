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
    
    /// 輸入的新聞關鍵字
    @State private var inputKeyword: String = ""
    
    /// 已套用的日期篩選條件
    @State private var appliedDateFilter: DateFilter?
    
    /// 篩選面板中的臨時日期範圍
    @State private var draftDateFilter: DateFilter = .defaultRange
    
    /// 是否顯示篩選面板
    @State private var isFilterSheetPresented: Bool = false
    
    /// 自動完成搜尋用的 SwiftData 環境
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \RecentSearch.createdAt, order: .reverse) private var recentSearches: [RecentSearch]
    
    // MARK: - View Body
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("搜尋新聞")
                .toolbar { toolbarContent }
                .sheet(isPresented: $isFilterSheetPresented) {
                    filterSheet
                }
        }
        .searchable(
            text: $inputKeyword,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "請輸入新聞關鍵字"
        )
        .searchSuggestions { recentSearchSuggestions }
        .onSubmit(of: .search) {
            await performSearch()
        }
        .task {
            await purgeExpiredRecentSearches()
        }
    }
}

// MARK: - ViewBuilder

extension SearchNewsView {
    
    /// 依據不同狀態顯示的主內容
    @ViewBuilder
    private var content: some View {
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
    private var idleStateView: some View {
        ContentUnavailableView {
            Label("開始搜尋新聞", symbols: .magnifyingglass)
        } description: {
            Text("輸入關鍵字或設定日期篩選，然後點擊搜尋。")
        }
    }
    
    @ViewBuilder
    private var emptyStateView: some View {
        ContentUnavailableView {
            Label("找不到符合的新聞", symbols: .newspaperFill)
        } description: {
            Text("請調整關鍵字或篩選條件後再試一次。")
        } actions: {
            Button {
                clearAllConditions()
            } label: {
                Label("清除條件", symbols: .xmarkCircleFill)
            }
        }
    }
    
    @ViewBuilder
    private var resultsList: some View {
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
    private func errorStateView(_ error: Error) -> some View {
        ErrorView {
            Label("搜尋失敗", symbols: .exclamationmarkTriangleFill)
        } description: {
            Text(error.localizedDescription)
        } actions: {
            AsyncButton {
                await performSearch()
            } label: {
                Label("重新嘗試", symbols: .arrowCounterclockwise)
            }
            .padding(.top, 8)
        }
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            Button {
                draftDateFilter = appliedDateFilter ?? .defaultRange
                isFilterSheetPresented = true
            } label: {
                Label(filterToolbarTitle, symbols: .line3HorizontalDecreaseCircle)
            }
            .accessibilityLabel("調整篩選條件")
            .tint(appliedDateFilter == nil ? .primary : .accentColor)
            
            AsyncButton {
                await performSearch()
            } label: {
                Label("搜尋", symbols: .magnifyingglass)
            }
            .keyboardShortcut(.defaultAction)
        }
    }
    
    @ViewBuilder
    private var recentSearchSuggestions: some View {
        let suggestions = validRecentSearches
        if suggestions.isEmpty { EmptyView() }
        else {
            Section("近期搜尋") {
                ForEach(suggestions) { search in
                    AsyncButton {
                        applyRecentSearch(search)
                        await performSearch(saveToRecents: false)
                    } label: {
                        Label(recentSearchTitle(for: search), symbols: .clock)
                    }
                    .contextMenu {
                        Button(role: .destructive) {
                            removeRecentSearch(search)
                        } label: {
                            Label("刪除此紀錄", symbols: .trash)
                        }
                    }
                }
                Button(role: .destructive) {
                    removeAllRecentSearches()
                } label: {
                    Label("清除全部", symbols: .trash)
                }
            }
        }
    }
    
    @ViewBuilder
    private var filterSheet: some View {
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
                        clearDateFilters()
                        restoreDraftDateFilter()
                        isFilterSheetPresented = false
                    }
                    .tint(.red)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("套用") {
                        guard draftDateFilter.startDate <= draftDateFilter.endDate else { return }
                        appliedDateFilter = draftDateFilter
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
    
    /// 日期篩選條件的封裝模型，用於記錄起訖日期狀態。
    struct DateFilter: Equatable {
        
        /// 篩選使用的開始日期。
        var startDate: Date
        
        /// 篩選使用的結束日期。
        var endDate: Date
        
        /// 預設日期範圍（往前一週至今天），供頁面初始化使用。
        static var defaultRange: DateFilter {
            let now = Date()
            let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: now) ?? now
            return DateFilter(startDate: weekAgo, endDate: now)
        }
    }
    
    /// 依據已套用的日期條件產生工具列標題文字。
    var filterToolbarTitle: String {
        guard let appliedDateFilter else { return "不限日期" }
        return "篩選：" + Self.displayFormatter.string(from: appliedDateFilter.startDate) + " - " + Self.displayFormatter.string(from: appliedDateFilter.endDate)
    }
    
    /// 使用者偏好的語系（依系統語言自動更新）。
    var userPreferredLocale: Locale {
        Locale.autoupdatingCurrent
    }
    
    /// 過濾出尚未過期的近期搜尋紀錄（僅保留一週內）。
    var validRecentSearches: [RecentSearch] {
        let cutoff = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? .distantPast
        return recentSearches.filter { $0.createdAt >= cutoff }
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
            return Self.displayFormatter.string(from: startDate) + " - " + Self.displayFormatter.string(from: endDate)
        }
        return "未命名搜尋"
    }
    
    /// 將選擇的近期搜尋套用到頁面狀態並關閉篩選面板。
    ///
    /// - Parameters:
    ///   - search: 使用者點選的近期搜尋紀錄。
    func applyRecentSearch(_ search: RecentSearch) {
        inputKeyword = search.keyword ?? ""
        if let startDate = search.startDate, let endDate = search.endDate {
            let filter = DateFilter(startDate: startDate, endDate: endDate)
            appliedDateFilter = filter
            draftDateFilter = filter
        } else {
            appliedDateFilter = nil
            draftDateFilter = .defaultRange
        }
        isFilterSheetPresented = false
    }
    
    /// 清除目前的日期篩選設定並回到預設範圍。
    func clearDateFilters() {
        appliedDateFilter = nil
        draftDateFilter = .defaultRange
    }
    
    /// 將編輯中的暫存日期恢復為目前已套用的狀態。
    func restoreDraftDateFilter() {
        draftDateFilter = appliedDateFilter ?? .defaultRange
    }
    
    /// 同時清除關鍵字與日期條件，回到最初狀態。
    func clearAllConditions() {
        inputKeyword = ""
        clearDateFilters()
    }
    
    /// 執行搜尋請求並視需求儲存成近期搜尋紀錄。
    ///
    /// - Parameters:
    ///   - saveToRecents: 是否需將此次搜尋條件寫入近期搜尋快取。
    func performSearch(saveToRecents: Bool = true) async {
        let keyword = inputKeyword.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedKeyword = keyword.isEmpty ? nil : keyword
        let startDate = appliedDateFilter?.startDate
        let endDate = appliedDateFilter?.endDate
        
        await viewModel.searchNews(
            with: normalizedKeyword,
            startDate: startDate.map { Self.backendFormatter.string(from: $0) },
            endDate: endDate.map { Self.backendFormatter.string(from: $0) }
        )
        
        if saveToRecents {
            persistRecentSearch(
                keyword: normalizedKeyword,
                startDate: startDate,
                endDate: endDate
            )
        }
    }
    
    /// 新增或更新近期搜尋紀錄，並同步儲存至 SwiftData。
    ///
    /// - Parameters:
    ///   - keyword: 使用者輸入的關鍵字，若僅使用日期篩選則為 `nil`。
    ///   - startDate: 篩選範圍的開始日期。
    ///   - endDate: 篩選範圍的結束日期。
    @MainActor
    func persistRecentSearch(keyword: String?, startDate: Date?, endDate: Date?) {
        guard keyword != nil || startDate != nil || endDate != nil else {
            return
        }
        
        if let existing = recentSearches.first(where: {
            $0.keyword == keyword &&
            $0.startDate == startDate &&
            $0.endDate == endDate
        }) {
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
        
        try? modelContext.save()
    }
    
    /// 刪除單筆近期搜尋。
    ///
    /// - Parameters:
    ///   - search: 要刪除的近期搜尋紀錄。
    @MainActor
    func removeRecentSearch(_ search: RecentSearch) {
        modelContext.delete(search)
        try? modelContext.save()
    }
    
    /// 刪除所有近期搜尋。
    @MainActor
    func removeAllRecentSearches() {
        recentSearches.forEach { modelContext.delete($0) }
        try? modelContext.save()
    }
    
    /// 清除已過期的近期搜尋紀錄。
    @MainActor
    func purgeExpiredRecentSearches() async {
        let cutoff = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? .distantPast
        var didMutate = false
        for search in recentSearches where search.createdAt < cutoff {
            modelContext.delete(search)
            didMutate = true
        }
        if didMutate {
            try? modelContext.save()
        }
    }
    
    /// 後端 API 要求的日期格式化器 (yyyy-MM-dd, GMT)。
    static let backendFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    /// 顯示於 UI 的日期格式化器 (medium style)。
    static let displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = .autoupdatingCurrent
        return formatter
    }()
}
