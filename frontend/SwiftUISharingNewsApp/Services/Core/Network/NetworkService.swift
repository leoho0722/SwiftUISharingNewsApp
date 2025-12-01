//
//  NetworkService.swift
//  SwiftUISharingNewsApp
//
//  Created by Leo Ho on 2025/11/1.
//

import Foundation

/// 定義網路服務的 Protocol
protocol NetworkServiceProtocol {
    
    /// 發送 GET 請求
    ///
    /// - Parameters:
    ///   - stage: API 部署環境
    ///   - route: API 路由
    ///   - requestObject: API 請求 body 物件
    /// - Returns: 伺服器回傳的資料
    /// - Throws: `NetworkServiceError`
    func get<E, D>(
        stage: NetworkConstants.APIStage,
        route: NetworkConstants.Routes,
        requestObject: E
    ) async throws(NetworkServiceError) -> D where E: Encodable, D: Decodable
    
    /// 發送 POST 請求
    ///
    /// - Parameters:
    ///   - stage: API 部署環境
    ///   - route: API 路由
    ///   - requestObject: API 請求 body 物件
    /// - Returns: 伺服器回傳的資料
    /// - Throws: `NetworkServiceError`
    func post<E, D>(
        stage: NetworkConstants.APIStage,
        route: NetworkConstants.Routes,
        requestObject: E
    ) async throws(NetworkServiceError) -> D where E: Encodable, D: Decodable
}

/// 網路服務實作類別
final class NetworkService: NetworkServiceProtocol {
    
    // MARK: - Properties
    
    /// URLSession 實例
    private let urlSession: URLSession
    
    // MARK: - Initializer
    
    /// 初始化
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30 // 設定請求超時時間為 30 秒
        urlSession = URLSession(configuration: configuration)
    }
    
    // MARK: - Public Methods
    
    func get<E, D>(
        stage: NetworkConstants.APIStage,
        route: NetworkConstants.Routes,
        requestObject: E
    ) async throws(NetworkServiceError) -> D where E: Encodable, D: Decodable {
        do {
            let request = try buildURLRequest(
                with: .get,
                stage: stage,
                route: route,
                body: requestObject
            )
            
            let (data, response) = try await urlSession.data(for: request)
            try validateResponse(response)
            let decodedData: D = try decodeResponseData(with: data)
            return decodedData
        } catch let error as DecodingError {
            throw NetworkServiceError.decodingFailed(decodingError: error)
        } catch let error as NetworkServiceError {
            throw error
        } catch {
            throw NetworkServiceError.unknownError(error: error)
        }
    }
    
    func post<E, D>(
        stage: NetworkConstants.APIStage,
        route: NetworkConstants.Routes,
        requestObject: E
    ) async throws(NetworkServiceError) -> D where E: Encodable, D: Decodable {
        do {
            let request = try buildURLRequest(
                with: .post,
                stage: stage,
                route: route,
                body: requestObject
            )
            
            let (data, response) = try await urlSession.data(for: request)
            try validateResponse(response)
            let decodedData: D = try decodeResponseData(with: data)
            return decodedData
        } catch let error as EncodingError {
            throw NetworkServiceError.encodingFailed(encodingError: error)
        } catch let error as DecodingError {
            throw NetworkServiceError.decodingFailed(decodingError: error)
        } catch let error as NetworkServiceError {
            throw error
        } catch {
            throw NetworkServiceError.unknownError(error: error)
        }
    }
}

// MARK: - Private Methods

private extension NetworkService {
    
    /// 建立 URLRequest
    ///
    /// - Parameters:
    ///   - method: HTTP 方法
    ///   - stage: API 部署環境
    ///   - route: API 路由
    ///   - body: 請求的主體資料
    /// - Returns: 建立好的 URLRequest
    func buildURLRequest<E>(
        with method: NetworkConstants.HTTPMethod,
        stage: NetworkConstants.APIStage,
        route: NetworkConstants.Routes,
        body: E
    ) throws(NetworkServiceError) -> URLRequest where E: Encodable {
        let baseURL = NetworkConstants.baseURL
        guard let url = URL(string: "\(baseURL)\(stage.rawValue)\(route.endpoint)") else {
            throw NetworkServiceError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = [
            NetworkConstants.HTTPHeaderField.contentType.rawValue : NetworkConstants.ContentType.json.rawValue
        ]
        
        switch method {
        case .post:
            do {
                request.httpBody = try JSONEncoder().encode(body)
            } catch {
                throw NetworkServiceError.encodingFailed(encodingError: error as! EncodingError)
            }
        case .get:
            break
        }
        
        return request
    }
    
    /// 驗證 HTTP Response
    ///
    /// - Parameters:
    ///   - response: URLResponse 物件
    /// - Throws: `NetworkServiceError`，當回應無效或狀態碼不在 200-299 範圍內
    func validateResponse(_ response: URLResponse) throws(NetworkServiceError) {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkServiceError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkServiceError.httpError(statusCode: httpResponse.statusCode)
        }
    }
    
    /// 將伺服器回傳的 Response Data 解析成 Decodable 物件
    ///
    /// - Parameters:
    ///   - responseData: 伺服器回傳的 Response Data
    /// - Returns: Decodable 物件
    /// - Throws: `DecodingError`
    func decodeResponseData<D>(with responseData: Data) throws -> D where D: Decodable {
        do {
            let jsonObject = try JSONSerialization.jsonObject(
                with: responseData,
                options: .fragmentsAllowed
            ) as! [String: Any]
            
            if let bodyObject = jsonObject["body"] as? [String: Any] {
                let bodyData = try JSONSerialization.data(withJSONObject: bodyObject, options: [])
                let decodedData = try JSONDecoder().decode(D.self, from: bodyData)
                return decodedData
            }
            else {
                let decodedData = try JSONDecoder().decode(D.self, from: responseData)
                return decodedData
            }
        } catch {
            throw error as! DecodingError
        }
    }
}
