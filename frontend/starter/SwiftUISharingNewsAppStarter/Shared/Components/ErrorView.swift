//
//  ErrorView.swift
//  SwiftUISharingNewsAppStarter
//
//  Created by Leo Ho on 2025/11/8.
//

import SwiftUI

/// 顯示錯誤狀態的通用視圖，支援自定義圖示、描述與操作按鈕
///
/// ### 使用範例
/// ```swift
/// // 1. 使用 String 與 SF Symbols
/// ErrorView("載入失敗", symbols: .exclamationmarkTriangleFill)
///
/// // 2. 包含重試按鈕
/// ErrorView("載入失敗", symbols: .exclamationmarkTriangleFill) {
///     Button("重試") {
///         // Retry action
///     }
/// }
///
/// // 3. 完全自定義內容
/// ErrorView {
///     Label("發生錯誤", systemImage: "xmark.circle")
/// } description: {
///     Text("請檢查您的網路連線")
/// } actions: {
///     Button("重試") { }
/// }
/// ```
struct ErrorView<Label, Description, Actions>: View where Label: View, Description: View, Actions: View {
    
    // MARK: - View Properties
    
    /// 錯誤文字和圖示
    let label: (() -> Label)?
    
    /// 錯誤描述
    let description: (() -> Description)?
    
    /// 錯誤處理動作
    let actions: (() -> Actions)
    
    // MARK: - View Body
    
    var body: some View {
        if let label, let description {
            ContentUnavailableView(
                label: label,
                description: description,
                actions: actions
            )
        }
        else if let label {
            ContentUnavailableView(label: label, actions: actions)
        }
    }
}

// MARK: - Init

// MARK: 使用 Label、Description、Actions 進行初始化

extension ErrorView {
    
    /// 使用自定義 ViewBuilder 建立錯誤視圖
    ///
    /// - Parameters:
    ///   - label: 錯誤標題或主要視覺內容
    ///   - description: 錯誤詳細描述（預設為 EmptyView）
    ///   - actions: 錯誤處理動作按鈕（預設為 EmptyView）
    init(
        @ViewBuilder label: @escaping () -> Label,
        @ViewBuilder description: @escaping () -> Description = { EmptyView() },
        @ViewBuilder actions: @escaping () -> Actions = { EmptyView() }
    ) {
        self.label = label
        self.description = description
        self.actions = actions
    }
}

// MARK: 使用 String 跟 SFSymbols 進行初始化

extension ErrorView where Label == SwiftUI.Label<Text, Image>, Description == Text?, Actions: View {
    
    /// 使用字串與 SF Symbols 快速建立錯誤視圖
    ///
    /// - Parameters:
    ///   - title: 錯誤標題文字
    ///   - symbols: SF Symbols 圖示
    ///   - description: 錯誤詳細描述文字（可選）
    ///   - actions: 錯誤處理動作按鈕（預設為 EmptyView）
    init<S>(
        _ title: S,
        symbols: SFSymbols,
        description: Text? = nil,
        @ViewBuilder actions: @escaping () -> Actions = { EmptyView() }
    ) where S: StringProtocol {
        self.init {
            Label(title, symbols: symbols)
        } description: {
            description
        } actions: {
            actions()
        }
    }
}

// MARK: - Preview

#Preview("使用 String 跟 SF Symbols init") {
    ErrorView("取得圖片失敗！", symbols: .exclamationmarkTriangleFill)
}

#Preview("只使用 Label init") {
    ErrorView {
        Label("取得圖片失敗！", symbols: .exclamationmarkTriangleFill)
    }
}
