//
//  LoadingView.swift
//  SwiftUISharingNewsApp
//
//  Created by Leo Ho on 2025/11/8.
//

import SwiftUI

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

// MARK: - Initializer

// MARK: 使用 String 進行初始化

extension LoadingView where Title == Text, Icon == EmptyView {
    
    init<S>(_ title: S) where S: StringProtocol {
        self.title = title as? String
        self.label = nil
    }
}

// MARK: 使用 Label 進行初始化

extension LoadingView where Title == Text, Icon == Image {
    
    init(@ViewBuilder label: @escaping () -> Label<Title, Icon>) {
        self.title = nil
        self.label = label
    }
}

// MARK: - Previews

#Preview("使用 String init") {
    LoadingView("取得圖片中...")
}

#Preview("使用 Label init") {
    LoadingView {
        Label("取得圖片失敗！", symbols: .exclamationmarkTriangleFill)
    }
}
