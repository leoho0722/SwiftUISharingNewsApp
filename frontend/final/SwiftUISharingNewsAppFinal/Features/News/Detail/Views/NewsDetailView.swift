//
//  NewsDetailView.swift
//  SwiftUISharingNewsAppFinal
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
    
    /// 選擇的附加檔案
    @State private var selectedAttachment: AttachmentFile?
    
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
        .sheet(item: $selectedAttachment) { attachment in
            previewFileSheet(attachment)
        }
    }
}

// MARK: - ViewBuilder

private extension NewsDetailView {
    
    /// 新聞標題
    @ViewBuilder
    var newsTitle: some View {
        Text(newsItem.title)
    }
    
    /// 新聞日期 (上：發布日期，下：最後更新日期)
    @ViewBuilder
    var newsDate: some View {
        VStack(alignment: .leading) {
            Text("發布日期：\(newsItem.publishDate)")
            Text("最後更新日期：\(newsItem.modifiedDate)")
        }
    }
    
    /// 新聞內容 (去除掉 HTML 標記)
    @ViewBuilder
    var newsContent: some View {
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
    var newsAttachmentFiles: some View {
        List {
            ForEach(
                Array(newsItem.attachmentFiles.enumerated()),
                id: \.element.id
            ) { index, file in
                Section("附件 \(index + 1)") {
                    Text("檔案名稱：\(file.fileName)")
                    Text("檔案說明：\(file.fileDescription)")
                    
                    if let fileURL = URL(string: file.fileURL) {
                        let result = viewModel.canPreviewFile(file.fileExtension)
                        if result.canPreview {
                            previewFileButton(file, fileType: result.fileType)
                        }
                        else {
                            LinkButton(title: "檔案連結", symbols: .link, url: fileURL)
                        }
                    }
                }
            }
        }
    }
    
    /// 預覽檔案按鈕
    ///
    /// - Parameters:
    ///   - file: 附加檔案
    ///   - fileType: 檔案類型
    @ViewBuilder
    func previewFileButton(
        _ file: AttachmentFile,
        fileType: NewsDetailViewModel.SupportedFileType
    ) -> some View {
        Button {
            selectedAttachment = file
        } label: {
            switch fileType {
            case .image:
                Label("預覽圖片", symbols: .photoFill)
                    .padding(5)
            case .file:
                Label("預覽檔案", symbols: .documentFill)
                    .padding(5)
            case .unknown:
                EmptyView()
            }
        }
    }
    
    /// 預覽檔案 Sheet
    ///
    /// - Parameters:
    ///   - attachment: 附加檔案
    @ViewBuilder
    func previewFileSheet(_ attachment: AttachmentFile) -> some View {
        let result = viewModel.canPreviewFile(attachment.fileExtension)
        
        NavigationStack {
            Group {
                if let fileURL = URL(string: attachment.fileURL) {
                    switch result.fileType {
                    case .image:
                        previewImageContent(fileURL)
                    default:
                        ErrorView {
                            Label("不支援預覽的檔案格式", symbols: .exclamationmarkTriangleFill)
                        } actions: {
                            LinkButton(url: fileURL) {
                                Label("檔案連結", symbols: .link)
                            }
                        }
                    }
                }
                else {
                    ErrorView {
                        Label("無效的檔案連結", symbols: .exclamationmarkTriangleFill)
                    }
                }
            }
            .navigationTitle(attachment.fileName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("關閉") {
                        selectedAttachment = nil
                    }
                }
            }
        }
        .presentationDetents(result.fileType == .image ? [.medium] : [.large])
    }
    
    /// 預覽圖片內容
    ///
    /// - Parameters:
    ///   - imageURL: 圖片連結
    @ViewBuilder
    func previewImageContent(_ imageURL: URL) -> some View {
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
