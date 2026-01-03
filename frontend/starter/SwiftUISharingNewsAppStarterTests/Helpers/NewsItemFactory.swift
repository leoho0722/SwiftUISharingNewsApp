//
//  NewsItemFactory.swift
//  SwiftUISharingNewsAppStarterTests
//
//  Created by Leo Ho on 2025/12/5.
//

import Foundation
@testable import SwiftUISharingNewsAppStarter

/// 測試資料工廠，用於建立測試用的 `NewsItem` 實例
enum NewsItemFactory {
    
    /// 建立單一測試用新聞項目
    ///
    /// - Parameters:
    ///   - title: 新聞標題，預設為 "測試新聞標題"
    ///   - content: 新聞內容，預設為 "測試新聞內容"
    ///   - publishDate: 發布日期，預設為 "2025-12-05"
    ///   - modifiedDate: 修改日期，預設為 "2025-12-05"
    ///   - attachmentFiles: 附件文件，預設為空陣列
    /// - Returns: 測試用 `NewsItem` 實例
    static func make(
        title: String = "測試新聞標題",
        content: String = "測試新聞內容",
        url: String = "https://example.com/news/1",
        publishDate: String = "2025-12-05",
        modifiedDate: String = "2025-12-05",
        attachmentFiles: [AttachmentFile] = []
    ) -> NewsItem {
        NewsItem(
            title: title,
            content: content,
            url: url,
            publishDate: publishDate,
            modifiedDate: modifiedDate,
            attachmentFiles: attachmentFiles
        )
    }
    
    /// 建立多筆測試用新聞項目
    ///
    /// - Parameter count: 要建立的數量
    /// - Returns: 測試用 `NewsItem` 陣列
    static func makeList(count: Int) -> [NewsItem] {
        (1...count).map { index in
            make(
                title: "測試新聞標題 \(index)",
                content: "測試新聞內容 \(index)",
                url: "https://example.com/news/\(index)",
                publishDate: "2025-12-0\(min(index, 9))"
            )
        }
    }
}
