//
//  NetworkServiceProtocol+Combine.swift
//  SwiftUISharingNewsAppFinal
//
//  Created by Leo Ho on 2026/1/4.
//

import Combine
import Foundation

/// 採用 Combine 模式設計的網路服務 Protocol
protocol NetworkServiceCombineProtocol {
    
    /// 發送 GET 請求
    ///
    /// - Parameter request: URLRequest 物件
    /// - Returns: AnyPublisher 物件
    func get<D>(
        request: URLRequest
    ) -> AnyPublisher<D, NetworkServiceError> where D: Decodable
    
    /// 發送 POST 請求
    ///
    /// - Parameter request: URLRequest 物件
    /// - Returns: AnyPublisher 物件
    func post<D>(
        request: URLRequest
    ) -> AnyPublisher<D, NetworkServiceError> where D: Decodable
}
