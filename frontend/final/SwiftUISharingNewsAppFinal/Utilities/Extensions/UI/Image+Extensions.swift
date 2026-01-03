//
//  Image+Extensions.swift
//  SwiftUISharingNewsAppFinal
//
//  Created by Leo Ho on 2026/1/4.
//

import SwiftUI

extension Image {
    
    /// 使用 `SFSymbols` enum 進行初始化，並基於 `init(systemName:)` 進行擴展
    ///
    /// - Parameter symbols: `SFSymbols`，對應於 SF Symbols 中的系統 icon
    init(symbols: SFSymbols) {
        self.init(systemName: symbols.iconName)
    }
}
