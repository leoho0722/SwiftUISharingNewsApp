//
//  NetworkServiceProtocol+CompletionHandler.swift
//  SwiftUISharingNewsAppStarter
//
//  Created by Leo Ho on 2026/1/4.
//

import Foundation

/// 採用 Completion Handler 模式設計的網路服務 Protocol
protocol NetworkServiceCompletionHandlerProtocol {
    
    /// 發送 GET 請求
    ///
    /// - Parameters:
    ///   - request: URLRequest 物件
    ///   - success: 請求成功時的要做的事
    ///   - failure: 請求失敗時的要做的事
    func get<D>(
        request: URLRequest,
        success: @escaping (D) -> Void,
        failure: @escaping (NetworkServiceError) -> Void
    ) where D: Decodable
    
    /// 發送 POST 請求
    ///
    /// - Parameters:
    ///   - request: URLRequest 物件
    ///   - success: 請求成功時的要做的事
    ///   - failure: 請求失敗時的要做的事
    func post<D>(
        request: URLRequest,
        success: @escaping (D) -> Void,
        failure: @escaping (NetworkServiceError) -> Void
    ) where D: Decodable
}