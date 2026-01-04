//
//  NetworkService.swift
//  SwiftUISharingNewsAppFinal
//
//  Created by Leo Ho on 2025/11/1.
//

import Combine
import Foundation

/// 網路服務實作類別
final class NetworkService {
    
    // MARK: - Properties
    
    /// URLSession 實例
    private let urlSession: URLSession
    
    // MARK: - Init
    
    /// 初始化 `NetworkService`
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30 // 設定請求超時時間為 30 秒
        urlSession = URLSession(configuration: configuration)
    }
}

// MARK: - Completion Handler Protocol Implementation

extension NetworkService: NetworkServiceCompletionHandlerProtocol {
    
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
    ) where D: Decodable {
        urlSession.dataTask(with: request) { [weak self] data, response, error in
            guard let self else { 
                return
            }
            
            if let error {
                failure(NetworkServiceError.unknownError(error: error))
                return
            }
            
            do {
                guard let response else {
                    failure(NetworkServiceError.invalidResponse)
                    return
                }
                try validateResponse(response)
                
                guard let data else {
                    failure(NetworkServiceError.emptyResponseData)
                    return
                }
                let decodedData: D = try decodeResponseData(with: data)
                success(decodedData)
            } catch let error as DecodingError {
                failure(NetworkServiceError.decodingFailed(decodingError: error))
            } catch let error as NetworkServiceError {
                failure(error)
            } catch {
                failure(NetworkServiceError.unknownError(error: error))
            }
        }.resume()
    }
    
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
    ) where D: Decodable {
        urlSession.dataTask(with: request) { [weak self] data, response, error in
            guard let self else { 
                return
            }
            
            if let error = error {
                failure(NetworkServiceError.unknownError(error: error))
                return
            }
            
            do {
                guard let response = response else {
                    failure(NetworkServiceError.invalidResponse)
                    return
                }
                try validateResponse(response)
                
                guard let data = data else {
                    failure(NetworkServiceError.emptyResponseData)
                    return
                }
                let decodedData: D = try decodeResponseData(with: data)
                success(decodedData)
            } catch let error as DecodingError {
                failure(NetworkServiceError.decodingFailed(decodingError: error))
            } catch let error as NetworkServiceError {
                failure(error)
            } catch {
                failure(NetworkServiceError.unknownError(error: error))
            }
        }.resume()
    }
}

// MARK: - Result Protocol Implementation

extension NetworkService: NetworkServiceResultProtocol {
    
    /// 發送 GET 請求
    ///
    /// - Parameters:
    ///   - request: URLRequest 物件
    ///   - completion: 請求完成時的要做的事
    func get<D>(
        request: URLRequest,
        completion: @escaping (Result<D, NetworkServiceError>) -> Void
    ) where D: Decodable {
        urlSession.dataTask(with: request) { [weak self] data, response, error in
            guard let self else { 
                return
            }
            
            if let error = error {
                completion(.failure(NetworkServiceError.unknownError(error: error)))
                return
            }
            
            do {
                guard let response = response else {
                    completion(.failure(NetworkServiceError.invalidResponse))
                    return
                }
                try validateResponse(response)
                
                guard let data = data else {
                    completion(.failure(NetworkServiceError.emptyResponseData))
                    return
                }
                let decodedData: D = try decodeResponseData(with: data)
                completion(.success(decodedData))
            } catch let error as DecodingError {
                completion(.failure(NetworkServiceError.decodingFailed(decodingError: error)))
            } catch let error as NetworkServiceError {
                completion(.failure(error))
            } catch {
                completion(.failure(NetworkServiceError.unknownError(error: error)))
            }
        }.resume()
    }
    
    /// 發送 POST 請求
    ///
    /// - Parameters:
    ///   - request: URLRequest 物件
    ///   - completion: 請求完成時的要做的事
    func post<D>(
        request: URLRequest,
        completion: @escaping (Result<D, NetworkServiceError>) -> Void
    ) where D: Decodable {
        urlSession.dataTask(with: request) { [weak self] data, response, error in
            guard let self else { 
                return
            }
            
            if let error = error {
                completion(.failure(NetworkServiceError.unknownError(error: error)))
                return
            }
            
            do {
                guard let response = response else {
                    completion(.failure(NetworkServiceError.invalidResponse))
                    return
                }
                try validateResponse(response)
                
                guard let data = data else {
                    completion(.failure(NetworkServiceError.emptyResponseData))
                    return
                }
                let decodedData: D = try decodeResponseData(with: data)
                completion(.success(decodedData))
            } catch let error as DecodingError {
                completion(.failure(NetworkServiceError.decodingFailed(decodingError: error)))
            } catch let error as NetworkServiceError {
                completion(.failure(error))
            } catch {
                completion(.failure(NetworkServiceError.unknownError(error: error)))
            }
        }.resume()
    }
}

// MARK: - Combine Protocol Implementation

extension NetworkService: NetworkServiceCombineProtocol {
    
    /// 發送 GET 請求
    ///
    /// - Parameter request: URLRequest 物件
    /// - Returns: AnyPublisher 物件
    func get<D>(
        request: URLRequest
    ) -> AnyPublisher<D, NetworkServiceError> where D: Decodable {
        urlSession.dataTaskPublisher(for: request)
            .tryMap { [weak self] data, response in
                guard let self else {
                    throw NetworkServiceError.unknownError(error: NSError(domain: "NetworkService", code: -1))
                }
                try validateResponse(response)
                return data
            }
            .tryMap { [weak self] data in
                guard let self else {
                    throw NetworkServiceError.unknownError(error: NSError(domain: "NetworkService", code: -1))
                }
                let decodedData: D = try decodeResponseData(with: data)
                return decodedData
            }
            .mapError { error in
                if let networkError = error as? NetworkServiceError {
                    return networkError
                }
                else if let decodingError = error as? DecodingError {
                    return NetworkServiceError.decodingFailed(decodingError: decodingError)
                }
                else {
                    return NetworkServiceError.unknownError(error: error)
                }
            }
            .eraseToAnyPublisher()
    }
    
    /// 發送 POST 請求
    ///
    /// - Parameter request: URLRequest 物件
    /// - Returns: AnyPublisher 物件
    func post<D>(
        request: URLRequest
    ) -> AnyPublisher<D, NetworkServiceError> where D: Decodable {
        urlSession.dataTaskPublisher(for: request)
            .tryMap { [weak self] data, response in
                guard let self else {
                    throw NetworkServiceError.unknownError(error: NSError(domain: "NetworkService", code: -1))
                }
                try validateResponse(response)
                return data
            }
            .tryMap { [weak self] data in
                guard let self else {
                    throw NetworkServiceError.unknownError(error: NSError(domain: "NetworkService", code: -1))
                }
                let decodedData: D = try decodeResponseData(with: data)
                return decodedData
            }
            .mapError { error in
                if let networkError = error as? NetworkServiceError {
                    return networkError
                }
                else if let decodingError = error as? DecodingError {
                    return NetworkServiceError.decodingFailed(decodingError: decodingError)
                }
                else {
                    return NetworkServiceError.unknownError(error: error)
                }
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Swift Concurrency Protocol Implementation

extension NetworkService: NetworkServiceSwiftConcurrencyProtocol {
    
    /// 發送 GET 請求
    ///
    /// 使用已建立的 `URLRequest` 物件發送 GET 請求。
    ///
    /// - Parameter request: URLRequest 物件
    /// - Returns: Decodable 物件
    /// - Throws: NetworkServiceError
    func get<D>(
        request: URLRequest
    ) async throws(NetworkServiceError) -> D where D: Decodable {
        do {
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
    
    /// 發送 POST 請求
    ///
    /// 使用已建立的 `URLRequest` 物件發送 POST 請求。
    ///
    /// - Parameter request: URLRequest 物件
    /// - Returns: Decodable 物件
    /// - Throws: NetworkServiceError
    func post<D>(
        request: URLRequest
    ) async throws(NetworkServiceError) -> D where D: Decodable {
        do {
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
}

// MARK: - Private Method

private extension NetworkService {
    
    /// 驗證 HTTP Response
    ///
    /// - Parameter response: URLResponse 物件
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
    /// - Parameter responseData: 伺服器回傳的 Response Data
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
