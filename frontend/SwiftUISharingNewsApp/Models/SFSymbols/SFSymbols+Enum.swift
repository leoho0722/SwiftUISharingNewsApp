//
//  SFSymbols+Enum.swift
//  SwiftUISharingNewsApp
//
//  Created by Leo Ho on 2025/11/2.
//

import Foundation

/// 定義專案中有用到的 SF Symbols icon 名稱
enum SFSymbols {
    
    /// SF Symbols icon 名稱：`exclamationmark.triangle.fill`
    case exclamationmarkTriangleFill
    
    /// SF Symbols icon 名稱：`arrow.counterclockwise`
    case arrowCounterclockwise
    
    /// SF Symbols icon 名稱
    var iconName: String {
        switch self {
        case .exclamationmarkTriangleFill:
            return "exclamationmark.triangle.fill"
        case .arrowCounterclockwise:
            return "arrow.counterclockwise"
        }
    }
}
