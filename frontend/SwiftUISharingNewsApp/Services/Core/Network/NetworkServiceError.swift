//
//  NetworkServiceError.swift
//  SwiftUISharingNewsApp
//
//  Created by Leo Ho on 2025/11/1.
//

import Foundation

/// 網路服務錯誤類型
enum NetworkServiceError: Error {
    
    /// 無效的 URL
    case invalidURL
    
    /// JSON 編碼失敗
    ///
    /// - Parameters:
    ///   - encodingError: 具體的編碼錯誤資訊
    case encodingFailed(encodingError: EncodingError)

    /// 無效的 Response
    case invalidResponse

    /// Response 資料為空
    case emptyResponseData

    /// HTTP 狀態碼錯誤
    ///
    /// - Parameters:
    ///   - statusCode: 回傳的 HTTP 狀態碼
    case httpError(statusCode: Int)
    
    /// JSON 解碼失敗
    ///
    /// - Parameters:
    ///   - decodingError: 具體的解碼錯誤資訊
    case decodingFailed(decodingError: DecodingError)
    
    /// 未知錯誤
    ///
    /// - Parameters:
    ///   - error: 原始錯誤
    case unknownError(error: Error)
}
