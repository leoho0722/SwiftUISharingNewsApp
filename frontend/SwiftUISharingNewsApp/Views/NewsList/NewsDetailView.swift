//
//  NewsDetailView.swift
//  SwiftUISharingNewsApp
//
//  Created by Leo Ho on 2025/11/2.
//

import SwiftUI

/// 新聞詳細內容畫面
struct NewsDetailView: View {
    
    // MARK: - View Properties
    
    /// 新聞項目
    let newsItem: NewsItem
    
    private let viewModel = NewsDetailViewModel()
    
    /// 開啟 URL 環境物件
    @Environment(\.openURL) private var openURL
    
    /// 是否進行預覽檔案
    @State private var isPreviewFile: Bool = false
    
    // MARK: - View Body
    
    var body: some View {
        Form {
            // 新聞標題
            newsTitle
            
            // 新聞日期
            newsDate
            
            // 新聞內容
            newsContent
            
            // 新聞連結
            newsURL
            
            // 附加檔案
            newsAttachmentFiles
        }
    }
}

// MARK: - ViewBuilder

extension NewsDetailView {
    
    /// 新聞標題
    @ViewBuilder
    private var newsTitle: some View {
        Text(newsItem.title)
    }
    
    /// 新聞日期 (上：發布日期，下：最後更新日期)
    @ViewBuilder
    private var newsDate: some View {
        VStack(alignment: .leading) {
            Text("發布日期：\(newsItem.publishDate)")
            Text("最後更新日期：\(newsItem.modifiedDate)")
        }
    }
    
    /// 新聞內容 (去除掉 HTML 標記)
    @ViewBuilder
    private var newsContent: some View {
        Text(newsItem.content.removingHTMLTags)
    }
    
    /// 新聞連結
    @ViewBuilder
    private var newsURL: some View {
        if let url = URL(string: newsItem.url) {
            Link("前往原文", destination: url)
        }
    }
    
    /// 新聞附加檔案
    @ViewBuilder
    private var newsAttachmentFiles: some View {
        List {
            ForEach(Array(newsItem.attachmentFiles.enumerated()), id: \.element.id) { index, file in
                Section("附件 \(index + 1)") {
                    Text("檔案名稱：\(file.fileName)")
                    Text("檔案說明：\(file.fileDescription)")
                    
                    if let fileURL = URL(string: file.fileURL) {
                        let result = viewModel.canPreviewFile(file.fileExtension)
                        if result.canPreview {
                            previewFileButton(fileURL, fileType: result.fileType)
                                .sheet(isPresented: $isPreviewFile) {
                                    previewFileSheet(fileURL, fileType: result.fileType)
                                }
                        }
                    }
                }
                
            }
        }
    }
    
    /// 檔案連結按鈕
    ///
    /// - Parameters:
    ///   - fileURL: 檔案連結
    @ViewBuilder
    private func fileLinkButton(_ fileURL: URL) -> some View {
        Button {
            openURL(fileURL)
        } label: {
            Label("檔案連結", symbols: .link)
                .padding(5)
        }
    }
    
    /// 預覽檔案按鈕
    ///
    /// - Parameters:
    ///   - fileType: 檔案類型
    @ViewBuilder
    private func previewFileButton(
        _ fileURL: URL,
        fileType: NewsDetailViewModel.SupportedFileType
    ) -> some View {
        Button {
            isPreviewFile.toggle()
        } label: {
            switch fileType {
            case .image:
                Label("預覽圖片", symbols: .photoFill)
                    .padding(5)
            case .file:
                Label("預覽檔案", symbols: .documentFill)
                    .padding(5)
            case .unknown:
                LinkButton(title: "檔案連結", symbols: .link, url: fileURL)
            }
        }
    }
    
    /// 預覽檔案 Sheet
    ///
    /// - Parameters:
    ///   - fileURL: 檔案連結
    ///   - fileType: 檔案類型
    @ViewBuilder
    private func previewFileSheet(
        _ fileURL: URL,
        fileType: NewsDetailViewModel.SupportedFileType
    ) -> some View {
        NavigationStack {
            Group {
                switch fileType {
                case .image:
                    previewImageContent(fileURL)
                default:
                    ErrorView {
                        Label("不支援的檔案格式", symbols: .exclamationmarkTriangleFill)
                    }
                }
            }
            .navigationTitle(fileType == .image ? "圖片預覽" : "檔案預覽")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("關閉") {
                        isPreviewFile = false
                    }
                }
            }
        }
        .presentationDetents(fileType == .image ? [.medium] : [.large])
    }
    
    /// 預覽圖片內容
    ///
    /// - Parameters:
    ///   - imageURL: 圖片連結
    @ViewBuilder
    private func previewImageContent(_ imageURL: URL) -> some View {
        AsyncImage(url: imageURL) { phase in
            switch phase {
            case .empty:
                LoadingView("取得圖片中...")
            case .success(let image):
                image
            case .failure:
                ErrorView {
                    Label("取得圖片失敗！", symbols: .exclamationmarkTriangleFill)
                }
            default:
                ErrorView {
                    Label("取得圖片失敗！", symbols: .exclamationmarkTriangleFill)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    NewsDetailView(newsItem: NewsItem.previewValue)
}
