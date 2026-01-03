//
//  LoadingView.swift
//  SwiftUISharingNewsAppFinal
//
//  Created by Leo Ho on 2025/11/8.
//

import SwiftUI

/// 顯示載入狀態的視圖，支援純文字或自定義 Label
///
/// ### 使用範例
/// ```swift
/// // 1. 使用純文字
/// LoadingView("載入中...")
///
/// // 2. 使用自定義 Label (文字 + Icon)
/// LoadingView {
///     Label("處理中...", systemImage: "gear")
/// }
/// ```
struct LoadingView<Title, Icon>: View where Title: View, Icon: View {
    
    // MARK: - View Properties
    
    /// 顯示在 Progress 底下的文字
    let title: String?
    
    /// 帶有文字和圖示的 Label
    let label: (() -> Label<Title, Icon>)?
    
    // MARK: - View Body
    
    var body: some View {
        if let title = title {
            ProgressView(title)
        }
        else if let label = label {
            ProgressView(label: label)
        }
    }
}

// MARK: - Init

// MARK: 使用 String 進行初始化

extension LoadingView where Title == Text, Icon == EmptyView {
    
    /// 使用純文字建立載入視圖
    ///
    /// - Parameter title: 載入時顯示的文字內容
    init<S>(_ title: S) where S: StringProtocol {
        self.title = title as? String
        self.label = nil
    }
}

// MARK: 使用 Label 進行初始化

extension LoadingView where Title == Text, Icon == Image {
    
    /// 使用 Label 建立載入視圖
    ///
    /// - Parameter label: 包含文字與圖示的 Label ViewBuilder
    init(@ViewBuilder label: @escaping () -> Label<Title, Icon>) {
        self.title = nil
        self.label = label
    }
}

// MARK: - Preview

#Preview("使用 String init") {
    LoadingView("取得圖片中...")
}

#Preview("使用 Label init") {
    LoadingView {
        Label("取得圖片失敗！", symbols: .exclamationmarkTriangleFill)
    }
}
