//
//  NewsService.swift
//  SwiftUISharingNewsAppStarter
//
//  Created by Leo Ho on 2025/11/1.
//

import Combine
import Foundation

/// 新聞服務實作類別
final class NewsService {
    
    // MARK: - Properties
    
    /// 網路服務實例
    private let networkService: NetworkServiceProtocol
    
    // MARK: - Init
    
    /// 初始化 `NewsService`
    ///
    /// - Parameter networkService: 網路服務實例
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
}

// MARK: - Completion Handler Protocol Implementation

extension NewsService: NewsServiceCompletionHandlerProtocol {
    
    /// 取得所有新聞資料
    ///
    /// - Parameters:
    ///   - success: 請求成功時的要做的事
    ///   - failure: 請求失敗時的要做的事
    func fetchNews(
        success: @escaping ([NewsItem]) -> Void,
        failure: @escaping (NewsServiceError) -> Void
    ) {
        do {
            let request = try NetworkRequestBuilder
                .create(
                    baseURL: NetworkConstants.baseURL,
                    stage: .default,
                    route: .fetchNews,
                    httpMethod: .get
                )
                .addHeader(.contentType, value: .json)
                .setTimeout(30)
                .build()
            
            networkService.get(request: request) { (responseObject: NewsResponseModel) in
                success(responseObject.newsItems)
            } failure: { error in
                failure(NewsServiceError.networkError(networkError: error))
            }
        } catch {
            failure(NewsServiceError.networkError(networkError: error))
        }
    }
    
    /// 根據條件 (關鍵字、開始日期、結束日期) 搜尋新聞資料
    ///
    /// - Parameters:
    ///   - keyword: 關鍵字
    ///   - startDate: 開始日期
    ///   - endDate: 結束日期
    ///   - success: 請求成功時的要做的事
    ///   - failure: 請求失敗時的要做的事
    func searchNews(
        with keyword: String?,
        startDate: String?,
        endDate: String?,
        success: @escaping ([NewsItem]) -> Void,
        failure: @escaping (NewsServiceError) -> Void
    ) {
        let requestObject = NewsRequestModel(
            keyword: keyword,
            startDate: startDate,
            endDate: endDate
        )
        do {
            let request = try NetworkRequestBuilder
                .create(
                    baseURL: NetworkConstants.baseURL,
                    stage: .default,
                    route: .searchNews,
                    httpMethod: .post
                )
                .addHeader(.contentType, value: .json)
                .setTimeout(30)
                .setBody(requestObject)
                .build()
            
            networkService.post(request: request) { (responseObject: NewsResponseModel) in
                success(responseObject.newsItems)
            } failure: { error in
                failure(NewsServiceError.networkError(networkError: error))
            }
        } catch {
            failure(NewsServiceError.networkError(networkError: error))
        }
    }
}

// MARK: - Result Protocol Implementation

extension NewsService: NewsServiceResultProtocol {
    
    /// 取得所有新聞資料
    ///
    /// - Parameter completion: 請求完成時的要做的事
    func fetchNews(completion: @escaping (Result<[NewsItem], NewsServiceError>) -> Void) {
        do {
            let request = try NetworkRequestBuilder
                .create(
                    baseURL: NetworkConstants.baseURL,
                    stage: .default,
                    route: .fetchNews,
                    httpMethod: .get
                )
                .addHeader(.contentType, value: .json)
                .setTimeout(30)
                .build()
            
            networkService.get(request: request) { (result: Result<NewsResponseModel, NetworkServiceError>) in
                switch result {
                case .success(let responseObject):
                    completion(.success(responseObject.newsItems))
                case .failure(let error):
                    completion(.failure(NewsServiceError.networkError(networkError: error)))
                }
            }
        } catch {
            completion(.failure(NewsServiceError.networkError(networkError: error)))
        }
    }
    
    /// 根據條件 (關鍵字、開始日期、結束日期) 搜尋新聞資料
    ///
    /// - Parameters:
    ///   - keyword: 關鍵字
    ///   - startDate: 開始日期
    ///   - endDate: 結束日期
    ///   - completion: 請求完成時的要做的事
    func searchNews(
        with keyword: String?,
        startDate: String?,
        endDate: String?,
        completion: @escaping (Result<[NewsItem], NewsServiceError>) -> Void
    ) {
        let requestObject = NewsRequestModel(
            keyword: keyword,
            startDate: startDate,
            endDate: endDate
        )
        do {
            let request = try NetworkRequestBuilder
                .create(
                    baseURL: NetworkConstants.baseURL,
                    stage: .default,
                    route: .searchNews,
                    httpMethod: .post
                )
                .addHeader(.contentType, value: .json)
                .setTimeout(30)
                .setBody(requestObject)
                .build()
            
            networkService.post(request: request) { (result: Result<NewsResponseModel, NetworkServiceError>) in
                switch result {
                case .success(let responseObject):
                    completion(.success(responseObject.newsItems))
                case .failure(let error):
                    completion(.failure(NewsServiceError.networkError(networkError: error)))
                }
            }
        } catch {
            completion(.failure(NewsServiceError.networkError(networkError: error)))
        }
    }
}

// MARK: - Combine Protocol Implementation

extension NewsService: NewsServiceCombineProtocol {
    
    /// 取得所有新聞資料
    ///
    /// - Returns: AnyPublisher 物件
    func fetchNews() -> AnyPublisher<[NewsItem], NewsServiceError> {
        do {
            let request = try NetworkRequestBuilder
                .create(
                    baseURL: NetworkConstants.baseURL,
                    stage: .default,
                    route: .fetchNews,
                    httpMethod: .get
                )
                .addHeader(.contentType, value: .json)
                .setTimeout(30)
                .build()
            
            let publisher: AnyPublisher<NewsResponseModel, NetworkServiceError> = networkService.get(request: request)
            return publisher
                .map { $0.newsItems }
                .mapError { NewsServiceError.networkError(networkError: $0) }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: NewsServiceError.networkError(networkError: error))
                .eraseToAnyPublisher()
        }
    }
    
    /// 根據條件 (關鍵字、開始日期、結束日期) 搜尋新聞資料
    ///
    /// - Parameters:
    ///   - keyword: 關鍵字
    ///   - startDate: 開始日期
    ///   - endDate: 結束日期
    /// - Returns: AnyPublisher 物件
    func searchNews(
        with keyword: String?,
        startDate: String?,
        endDate: String?
    ) -> AnyPublisher<[NewsItem], NewsServiceError> {
        let requestObject = NewsRequestModel(
            keyword: keyword,
            startDate: startDate,
            endDate: endDate
        )
        do {
            let request = try NetworkRequestBuilder
                .create(
                    baseURL: NetworkConstants.baseURL,
                    stage: .default,
                    route: .searchNews,
                    httpMethod: .post
                )
                .addHeader(.contentType, value: .json)
                .setTimeout(30)
                .setBody(requestObject)
                .build()
            
            let publisher: AnyPublisher<NewsResponseModel, NetworkServiceError> = networkService.post(request: request)
            return publisher
                .map { $0.newsItems }
                .mapError { NewsServiceError.networkError(networkError: $0) }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: NewsServiceError.networkError(networkError: error))
                .eraseToAnyPublisher()
        }
    }
}

// MARK: - Swift Concurrency Protocol Implementation

extension NewsService: NewsServiceSwiftConcurrencyProtocol {
    
    /// 取得所有新聞資料
    ///
    /// - Returns: 新聞資料陣列
    /// - Throws: `NewsServiceError`
    func fetchNews() async throws(NewsServiceError) -> [NewsItem] {
        do {
            let request = try NetworkRequestBuilder
                .create(
                    baseURL: NetworkConstants.baseURL,
                    stage: .default,
                    route: .fetchNews,
                    httpMethod: .get
                )
                .addHeader(.contentType, value: .json)
                .setTimeout(30)
                .build()
            
            let responseObject: NewsResponseModel = try await networkService.get(request: request)
            return responseObject.newsItems
        } catch {
            throw NewsServiceError.networkError(networkError: error)
        }
    }
    
    /// 根據條件 (關鍵字、開始日期、結束日期) 搜尋新聞資料
    ///
    /// - Parameters:
    ///   - keyword: 關鍵字
    ///   - startDate: 開始日期
    ///   - endDate: 結束日期
    /// - Returns: 符合條件的新聞資料陣列
    /// - Throws: `NewsServiceError`
    func searchNews(
        with keyword: String?,
        startDate: String?,
        endDate: String?
    ) async throws(NewsServiceError) -> [NewsItem] {
        let requestObject = NewsRequestModel(
            keyword: keyword,
            startDate: startDate,
            endDate: endDate
        )
        do {
            let request = try NetworkRequestBuilder
                .create(
                    baseURL: NetworkConstants.baseURL,
                    stage: .default,
                    route: .searchNews,
                    httpMethod: .post
                )
                .addHeader(.contentType, value: .json)
                .setTimeout(30)
                .setBody(requestObject)
                .build()
            
            let responseObject: NewsResponseModel = try await networkService.post(request: request)
            return responseObject.newsItems
        } catch {
            throw NewsServiceError.networkError(networkError: error)
        }
    }
}
