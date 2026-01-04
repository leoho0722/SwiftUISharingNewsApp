//
//  NetworkServiceProtocol+Result.swift
//  SwiftUISharingNewsAppFinal
//
//  Created by Leo Ho on 2026/1/4.
//

import Foundation

/// 採用 Result 模式設計的網路服務 Protocol
protocol NetworkServiceResultProtocol {
    
    /// 發送 GET 請求
    ///
    /// - Parameters:
    ///   - request: URLRequest 物件
    ///   - completion: 請求完成時的要做的事
    func get<D>(
        request: URLRequest,
        completion: @escaping (Result<D, NetworkServiceError>) -> Void
    ) where D: Decodable
    
    /// 發送 POST 請求
    ///
    /// - Parameters:
    ///   - request: URLRequest 物件
    ///   - completion: 請求完成時的要做的事
    func post<D>(
        request: URLRequest,
        completion: @escaping (Result<D, NetworkServiceError>) -> Void
    ) where D: Decodable
}
