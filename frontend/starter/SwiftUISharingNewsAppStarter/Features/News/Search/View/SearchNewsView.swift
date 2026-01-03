//
//  SearchNewsView.swift
//  SwiftUISharingNewsAppStarter
//
//  Created by Leo Ho on 2025/11/4.
//

import SwiftUI

/// 新聞搜尋頁面
struct SearchNewsView: View {
    
    // MARK: - View Properties
    
    /// ViewModel
    @State private var viewModel = SearchNewsViewModel()
    
    /// 篩選面板中的臨時日期範圍
    @State private var draftDateFilter: SearchNewsViewModel.DateFilter = .defaultRange
    
    /// 是否顯示篩選面板
    @State private var isFilterSheetPresented: Bool = false
    
    /// 網路狀態監控器
    @Environment(\.networkMonitor) private var networkMonitor
    
    // MARK: - View Body
    
    var body: some View {
        if networkMonitor.isConnected {
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
            .onSubmit(of: .search) {
                await viewModel.performSearch()
            }
        }
        else {
            NetworkErrorView()
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
                }
                else {
                    resultsList
                }
            case .error(let error):
                errorStateView(error)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemGroupedBackground))
    }
    
    /// 閒置狀態畫面
    @ViewBuilder
    var idleStateView: some View {
        ContentUnavailableView {
            Label("開始搜尋新聞", symbols: .magnifyingglass)
        } description: {
            Text("輸入關鍵字或設定日期篩選，然後點擊搜尋。")
        }
    }
    
    /// 查無新聞狀態畫面
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
    
    /// 搜尋到的新聞列表清單
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
    /// - Parameter error: 透過 ViewModel 回傳的錯誤。
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
    
    /// Navigation RightBarButtonItems
    @ToolbarContentBuilder
    var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            Button {
                draftDateFilter = viewModel.restoreDraftDateFilter()
                isFilterSheetPresented = true
            } label: {
                Image(symbols: .line3HorizontalDecreaseCircle)
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
    
    /// 日期篩選 Sheet
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
            .environment(\.locale, .autoupdatingCurrent)
            .navigationTitle("篩選條件")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        draftDateFilter = viewModel.restoreDraftDateFilter()
                        isFilterSheetPresented = false
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button("重設篩選") {
                        viewModel.clearDateFilters()
                        draftDateFilter = viewModel.restoreDraftDateFilter()
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
}
