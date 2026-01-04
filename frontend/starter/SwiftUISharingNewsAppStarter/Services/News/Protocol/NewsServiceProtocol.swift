//
//  NewsServiceProtocol.swift
//  SwiftUISharingNewsAppStarter
//
//  Created by Leo Ho on 2026/1/4.
//

import Foundation

/// 定義新聞服務的 Protocol 別名
typealias NewsServiceProtocol = NewsServiceCompletionHandlerProtocol &
                                NewsServiceResultProtocol &
                                NewsServiceCombineProtocol &
                                NewsServiceSwiftConcurrencyProtocol
