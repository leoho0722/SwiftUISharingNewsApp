//
//  NetworkServiceProtocol+SwiftConcurrency.swift
//  SwiftUISharingNewsAppFinal
//
//  Created by Leo Ho on 2026/1/4.
//

import Foundation

/// 採用 Swift Concurrency 模式設計的網路服務 Protocol
protocol NetworkServiceSwiftConcurrencyProtocol {
    
    /// 發送 GET 請求
    ///
    /// - Parameter request: URLRequest 物件
    /// - Returns: Decodable 物件
    /// - Throws: NetworkServiceError
    func get<D>(
        request: URLRequest
    ) async throws(NetworkServiceError) -> D where D: Decodable
    
    /// 發送 POST 請求
    ///
    /// - Parameter request: URLRequest 物件
    /// - Returns: Decodable 物件
    /// - Throws: NetworkServiceError
    func post<D>(
        request: URLRequest
    ) async throws(NetworkServiceError) -> D where D: Decodable
}
