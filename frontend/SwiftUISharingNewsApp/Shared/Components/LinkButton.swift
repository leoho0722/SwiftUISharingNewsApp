//
//  LinkButton.swift
//  SwiftUISharingNewsApp
//
//  Created by Leo Ho on 2025/11/9.
//

import SwiftUI

/// 封裝開啟 URL 的按鈕元件，支援多種初始化方式
///
/// ### 使用範例
/// ```swift
/// // 1. 使用 String 與 SF Symbols
/// LinkButton(title: "前往官網", symbols: .globe, url: URL(string: "https://example.com")!)
///
/// // 2. 使用 System Image
/// LinkButton(title: "分享", systemImage: "square.and.arrow.up", url: shareURL)
///
/// // 3. 完全自定義內容
/// LinkButton(url: targetURL) {
///     HStack {
///         Text("點擊查看")
///         Image(systemName: "arrow.right")
///     }
/// }
/// ```
struct LinkButton<Content>: View where Content: View {
    
    // MARK: - View Properties
    
    /// Link 標題與 icon
    let label: () -> Content
    
    /// Link URL
    let url: URL
    
    @Environment(\.openURL) private var openURL
    
    // MARK: - View Body
    
    var body: some View {
        Button {
            openURL(url)
        } label: {
            label()
                .padding()
        }
    }
}

// MARK: - Initializer

extension LinkButton where Content == Label<Text, Image> {
    
    /// 使用自定義 ViewBuilder 建立連結按鈕
    ///
    /// - Parameters:
    ///   - url: 目標 URL
    ///   - label: 按鈕外觀內容
    init(url: URL, @ViewBuilder label: @escaping () -> Content) {
        self.label = label
        self.url = url
    }
    
    /// 使用 SFSymbols 建立連結按鈕
    ///
    /// - Parameters:
    ///   - title: 按鈕標題
    ///   - symbols: SF Symbols 圖示
    ///   - url: 目標 URL
    init(title: String, symbols: SFSymbols, url: URL) {
        self.label = { Label(title, symbols: symbols) }
        self.url = url
    }
    
    /// 使用 System Image 建立連結按鈕
    ///
    /// - Parameters:
    ///   - title: 按鈕標題
    ///   - systemImage: System Image 名稱
    ///   - url: 目標 URL
    init(title: String, systemImage: String, url: URL) {
        self.label = { Label(title, systemImage: systemImage) }
        self.url = url
    }
    
    /// 使用 Asset Image 建立連結按鈕
    ///
    /// - Parameters:
    ///   - title: 按鈕標題
    ///   - image: Asset Image 名稱
    ///   - url: 目標 URL
    init(title: String, image: String, url: URL) {
        self.label = { Label(title, image: image) }
        self.url = url
    }
}

// MARK: - Previews

#Preview {
    LinkButton(
        title: "檔案連結",
        symbols: .link,
        url: URL(string: "https://www.apple.com")!
    )
}
