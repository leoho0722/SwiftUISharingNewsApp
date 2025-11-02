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
    
    let newsItem: NewsItem
    
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
                        Link("檔案連結", destination: fileURL)
                    }
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    NewsDetailView(newsItem: NewsItem.previewValue)
}
