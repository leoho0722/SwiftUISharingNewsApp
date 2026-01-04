//
//  NetworkServiceProtocol.swift
//  SwiftUISharingNewsAppStarter
//
//  Created by Leo Ho on 2026/1/4.
//

import Foundation

/// 定義網路服務的 Protocol 別名
typealias NetworkServiceProtocol = NetworkServiceCompletionHandlerProtocol & 
                                   NetworkServiceResultProtocol & 
                                   NetworkServiceCombineProtocol & 
                                   NetworkServiceSwiftConcurrencyProtocol