//
//  ErrorView.swift
//  SwiftUISharingNewsApp
//
//  Created by Leo Ho on 2025/11/8.
//

import SwiftUI

struct ErrorView<Label, Description, Actions>: View where Label: View, Description: View, Actions: View {
    
    // MARK: - View Properties
    
    /// 錯誤文字和圖示
    let label: (() -> Label)?
    
    /// 錯誤描述
    let description: (() -> Description)?
    
    /// 錯誤處理動作
    let actions: (() -> Actions)
    
    /// 錯誤文字
    let title: String?
    
    /// 錯誤圖示 (SF Symbols)
    let symbols: SFSymbols?
    
    // MARK: - View Body
    
    var body: some View {
        if let label {
            ContentUnavailableView(label: label)
        }
        else if let label, let description {
            ContentUnavailableView(label: label, description: description)
        }
        else if let label, let description {
            ContentUnavailableView(label: label, description: description, actions: actions)
        }
        else if let title, let symbols {
            ContentUnavailableView {
                SwiftUI.Label(title, symbols: symbols)
            } actions: {
                actions()
            }
        }
        else if let title, let symbols, let description {
            ContentUnavailableView {
                SwiftUI.Label(title, symbols: symbols)
            } description: {
                description()
            } actions: {
                actions()
            }
        }
    }
}

// MARK: - Initializer

// MARK: 使用 String 跟 SFSymbols 進行初始化

extension ErrorView where Label == SwiftUI.Label<Text, Image>, Description == Text?, Actions: View {
    
    init<S>(
        _ title: S,
        symbols: SFSymbols,
        description: Text? = nil,
        @ViewBuilder actions: @escaping () -> Actions = { EmptyView() }
    ) where S: StringProtocol {
        self.title = title as? String
        self.symbols = symbols
        
        self.label = nil
        if let description {
            self.description = { description }
        }
        else {
            self.description = nil
        }
        self.actions = actions
    }
}

// MARK: 使用 Label、Description、Actions 進行初始化

extension ErrorView {
    
    init(
        @ViewBuilder label: @escaping () -> Label,
        @ViewBuilder description: @escaping () -> Description = { EmptyView() },
        @ViewBuilder actions: @escaping () -> Actions = { EmptyView() }
    ) {
        self.label = label
        self.description = description
        self.actions = actions
        
        self.title = nil
        self.symbols = nil
    }
}

// MARK: - Previews

#Preview("使用 String 跟 SF Symbols init") {
    ErrorView("取得圖片失敗！", symbols: .exclamationmarkTriangleFill)
}

#Preview("只使用 Label init") {
    ErrorView {
        Label("取得圖片失敗！", symbols: .exclamationmarkTriangleFill)
    }
}
