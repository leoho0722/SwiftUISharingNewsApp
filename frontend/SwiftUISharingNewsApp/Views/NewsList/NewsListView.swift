//
//  NewsListView.swift
//  SwiftUISharingNewsApp
//
//  Created by Leo Ho on 2025/11/1.
//

import SwiftUI

/// 新聞列表畫面
struct NewsListView: View {
    
    // MARK: - View Properties
    
    /// ViewModel
    @State private var viewModel = NewsListViewModel()
    
    // MARK: - View Body
    
    var body: some View {
        NavigationStack {
            VStack {
                switch viewModel.viewState {
                case .idle, .loading:
                    loadingView
                case .loaded:
                    newsList
                case .error:
                    errorView
                }
            }
            .navigationTitle("新聞列表")
            .navigationBarTitleDisplayMode(.automatic)
        }
        .task {
            await viewModel.fetchNews()
        }
    }
}

// MARK: - ViewBuilder

extension NewsListView {
    
    /// 載入畫面
    @ViewBuilder
    private var loadingView: some View {
        LoadingView("取得新聞資料中...")
    }
    
    /// 新聞列表（依發布「日期」分組成 Section），所有邏輯由 ViewModel 提供
    @ViewBuilder
    private var newsList: some View {
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
    }
    
    /// 錯誤畫面
    @ViewBuilder
    private var errorView: some View {
        ErrorView {
            Label("取得新聞資料失敗！", symbols: .exclamationmarkTriangleFill)
        } actions: {
            Button {
                await viewModel.fetchNews()
            } label: {
                Label("點擊重試", symbols: .arrowCounterclockwise)
            }
            .padding()
        }
    }
}

// MARK: - Preview

#Preview {
    NewsListView()
}
