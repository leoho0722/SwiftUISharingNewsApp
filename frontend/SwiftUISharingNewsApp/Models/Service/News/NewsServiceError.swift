//
//  NewsServiceError.swift
//  SwiftUISharingNewsApp
//
//  Created by Leo Ho on 2025/11/1.
//

import Foundation

/// 定義新聞服務的錯誤類型
enum NewsServiceError: Error {
    
    /// 網路錯誤
    /// - Parameters:
    ///   - networkError: 具體的網路錯誤資訊
    case networkError(networkError: NetworkServiceError)
    
    /// 未知錯誤
    /// 
    /// - Parameters:
    ///   - error: 原始錯誤
    case unknownError(error: Error)
}
