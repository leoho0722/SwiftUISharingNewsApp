//
//  Label+Extensions.swift
//  SwiftUISharingNewsApp
//
//  Created by Leo Ho on 2025/11/2.
//

import SwiftUI

extension Label where Title == Text, Icon == Image {
    
    /// 使用 `SFSymbols` enum 進行初始化，並基於 `init(_ titleKey:, systemImage:)` 進行擴展
    ///
    /// - Parameters:
    ///   - titleKey: 要顯示的文字
    ///   - symbols: `SFSymbols`，對應於 SF Symbols 中的系統 icon
    init(_ titleKey: LocalizedStringKey, symbols: SFSymbols) {
        self.init(titleKey, systemImage: symbols.iconName)
    }
    
    /// 使用 `SFSymbols` enum 進行初始化，並基於 `init(_ titleResource:, systemImage:)` 進行擴展
    ///
    /// - Parameters:
    ///   - titleKey: 要顯示的文字
    ///   - symbols: `SFSymbols`，對應於 SF Symbols 中的系統 icon
    init(_ titleResource: LocalizedStringResource, symbols: SFSymbols) {
        self.init(titleResource, systemImage: symbols.iconName)
    }
    
    /// 使用 `SFSymbols` enum 進行初始化，並基於 `init(_ title:, systemImage:)` 進行擴展
    ///
    /// - Parameters:
    ///   - title: 要顯示的文字
    ///   - symbols: `SFSymbols`，對應於 SF Symbols 中的系統 icon
    init<S>(_ title: S, symbols: SFSymbols) where S: StringProtocol {
        self.init(title, systemImage: symbols.iconName)
    }
}
