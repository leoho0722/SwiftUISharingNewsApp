//
//  NetworkRequestBuilder.swift
//  SwiftUISharingNewsAppStarter
//
//  Created by Leo Ho on 2026/1/4.
//

import Foundation

/// 網路請求建構器
///
/// 使用 Builder Pattern 建立 `URLRequest` 物件，提供流暢的鏈式呼叫介面。
///
/// ## 使用範例
///
/// ```swift
/// let request = try NetworkRequestBuilder()
///     .setBaseURL(NetworkConstants.baseURL)
///     .setStage(.default)
///     .setRoute(.fetchNews)
///     .setMethod(.get)
///     .addHeader(.contentType, value: .json)
///     .setTimeout(30)
///     .build()
/// ```
///
/// - Note: 此類別符合 Swift 6 的 `Sendable` 規範，可安全地在並發環境中使用。
struct NetworkRequestBuilder {
    
    // MARK: - Properties
    
    /// 基本的 API URL
    private let baseURL: URL
    
    /// API 部署環境
    private let stage: NetworkConfiguration.APIStage
    
    /// API 路由
    private let route: NetworkConfiguration.Routes
    
    /// HTTP 方法
    private let httpMethod: NetworkConfiguration.HTTPMethod
    
    /// HTTP 標頭欄位集合
    private let headers: [String: String]
    
    /// HTTP Query 參數集合
    private let queryParams: [String: String]
    
    /// 請求主體資料
    private let bodyData: Data?
    
    /// 請求超時時間（秒）
    private let timeout: TimeInterval
    
    // MARK: - Init
    
    /// 私有初始化方法
    ///
    /// 用於內部建立新的建構器實例，支援不可變的鏈式呼叫。
    ///
    /// - Parameters:
    ///   - baseURL: 基本的 API URL
    ///   - stage: API 部署環境
    ///   - route: API 路由
    ///   - httpMethod: HTTP 方法
    ///   - headers: HTTP 標頭欄位集合
    ///   - queryParams: HTTP Query 參數集合
    ///   - bodyData: 請求主體資料
    ///   - timeout: 請求超時時間
    private init(
        baseURL: URL,
        stage: NetworkConfiguration.APIStage,
        route: NetworkConfiguration.Routes,
        httpMethod: NetworkConfiguration.HTTPMethod,
        headers: [String: String],
        queryParams: [String: String],
        bodyData: Data?,
        timeout: TimeInterval
    ) {
        self.baseURL = baseURL
        self.stage = stage
        self.route = route
        self.httpMethod = httpMethod
        self.headers = headers
        self.queryParams = queryParams
        self.bodyData = bodyData
        self.timeout = timeout
    }
}

// MARK: - Internal Method

extension NetworkRequestBuilder {
    
    /// 建立新的請求建構器
    ///
    /// - Parameters:
    ///   - baseURL: 基本的 API URL
    ///   - stage: API 部署環境
    ///   - route: API 路由
    ///   - httpMethod: HTTP 方法
    /// - Returns: `NetworkRequestBuilder` 實例
    static func create(
        baseURL: URL,
        stage: NetworkConfiguration.APIStage,
        route: NetworkConfiguration.Routes,
        httpMethod: NetworkConfiguration.HTTPMethod
    ) throws(NetworkServiceError) -> NetworkRequestBuilder {
        return NetworkRequestBuilder(
            baseURL: baseURL,
            stage: stage,
            route: route,
            httpMethod: httpMethod,
            headers: [:],
            queryParams: [:],
            bodyData: nil,
            timeout: 30
        )
    }
}

// MARK: - Builder Method

extension NetworkRequestBuilder {
    
    /// 設定基本的 API URL
    ///
    /// - Parameter url: 基本的 API URL
    /// - Returns: 新的建構器實例
    ///
    /// ## 使用範例
    ///
    /// ```swift
    /// let builder = NetworkRequestBuilder()
    ///     .setBaseURL(NetworkConstants.baseURL)
    /// ```
    func setBaseURL(_ url: URL) -> NetworkRequestBuilder {
        return NetworkRequestBuilder(
            baseURL: url,
            stage: stage,
            route: route,
            httpMethod: httpMethod,
            headers: headers,
            queryParams: queryParams,
            bodyData: bodyData,
            timeout: timeout
        )
    }
    
    /// 設定 API 部署環境
    ///
    /// - Parameter stage: API 部署環境
    /// - Returns: 新的建構器實例
    ///
    /// ## 使用範例
    ///
    /// ```swift
    /// let builder = NetworkRequestBuilder()
    ///     .setStage(.default)
    /// ```
    func setStage(_ stage: NetworkConfiguration.APIStage) -> NetworkRequestBuilder {
        return NetworkRequestBuilder(
            baseURL: baseURL,
            stage: stage,
            route: route,
            httpMethod: httpMethod,
            headers: headers,
            queryParams: queryParams,
            bodyData: bodyData,
            timeout: timeout
        )
    }
    
    /// 設定 API 路由
    ///
    /// - Parameter route: API 路由
    /// - Returns: 新的建構器實例
    ///
    /// ## 使用範例
    ///
    /// ```swift
    /// let builder = NetworkRequestBuilder()
    ///     .setRoute(.fetchNews)
    /// ```
    func setRoute(_ route: NetworkConfiguration.Routes) -> NetworkRequestBuilder {
        return NetworkRequestBuilder(
            baseURL: baseURL,
            stage: stage,
            route: route,
            httpMethod: httpMethod,
            headers: headers,
            queryParams: queryParams,
            bodyData: bodyData,
            timeout: timeout
        )
    }
    
    /// 設定 HTTP 方法
    ///
    /// - Parameter method: HTTP 方法 (GET、POST 等)
    /// - Returns: 新的建構器實例
    ///
    /// ## 使用範例
    ///
    /// ```swift
    /// let builder = NetworkRequestBuilder()
    ///     .setMethod(.get)
    /// ```
    func setMethod(_ method: NetworkConfiguration.HTTPMethod) -> NetworkRequestBuilder {
        return NetworkRequestBuilder(
            baseURL: baseURL,
            stage: stage,
            route: route,
            httpMethod: method,
            headers: headers,
            queryParams: queryParams,
            bodyData: bodyData,
            timeout: timeout
        )
    }
    
    /// 新增 HTTP 標頭欄位
    ///
    /// - Parameters:
    ///   - field: HTTP 標頭欄位類型
    ///   - value: 標頭欄位的值
    /// - Returns: 新的建構器實例
    ///
    /// ## 使用範例
    ///
    /// ```swift
    /// let builder = NetworkRequestBuilder()
    ///     .addHeader(.contentType, value: NetworkConfiguration.ContentType.json.rawValue)
    ///     .addHeader(.authorization, value: "Bearer token123")
    /// ```
    func addHeader(
        _ field: NetworkConfiguration.HTTPHeaderField,
        value: String
    ) -> NetworkRequestBuilder {
        var newHeaders = headers
        newHeaders[field.rawValue] = value
        
        return NetworkRequestBuilder(
            baseURL: baseURL,
            stage: stage,
            route: route,
            httpMethod: httpMethod,
            headers: newHeaders,
            queryParams: queryParams,
            bodyData: bodyData,
            timeout: timeout
        )
    }
    
    /// 新增 HTTP 標頭欄位
    ///
    /// - Parameters:
    ///   - field: HTTP 標頭欄位類型
    ///   - value: 標頭欄位的值
    /// - Returns: 新的建構器實例
    ///
    /// ## 使用範例
    ///
    /// ```swift
    /// let builder = NetworkRequestBuilder()
    ///     .addHeader(.contentType, value: .json)
    ///     .addAuthorization(.bearer("abc123"))
    /// ```
    func addHeader(
        _ field: NetworkConfiguration.HTTPHeaderField,
        value: NetworkConfiguration.ContentType
    ) -> NetworkRequestBuilder {
        var newHeaders = headers
        newHeaders[field.rawValue] = value.rawValue
        
        return NetworkRequestBuilder(
            baseURL: baseURL,
            stage: stage,
            route: route,
            httpMethod: httpMethod,
            headers: newHeaders,
            queryParams: queryParams,
            bodyData: bodyData,
            timeout: timeout
        )
    }
    
    /// 新增授權標頭
    ///
    /// - Parameter auth: 授權類型
    /// - Returns: 新的建構器實例
    ///
    /// ## 使用範例
    ///
    /// ```swift
    /// // Bearer Token
    /// let builder = NetworkRequestBuilder()
    ///     .addAuthorization(.bearer("abc123"))
    ///
    /// // Basic 授權
    /// let builder = NetworkRequestBuilder()
    ///     .addAuthorization(.basic(username: "user", password: "pass"))
    ///
    /// // API Key
    /// let builder = NetworkRequestBuilder()
    ///     .addAuthorization(.apiKey("your-api-key"))
    /// ```
    func addAuthorization(
        _ auth: NetworkConfiguration.AuthorizationType
    ) -> NetworkRequestBuilder {
        var newHeaders = headers
        newHeaders[NetworkConfiguration.HTTPHeaderField.authorization.rawValue] = auth.headerValue
        
        return NetworkRequestBuilder(
            baseURL: baseURL,
            stage: stage,
            route: route,
            httpMethod: httpMethod,
            headers: newHeaders,
            queryParams: queryParams,
            bodyData: bodyData,
            timeout: timeout
        )
    }
    
    /// 設定請求主體資料
    ///
    /// 此方法會將可編碼的物件轉換為 JSON 格式的資料。
    ///
    /// - Parameter body: 符合 `Encodable` 協定的請求主體物件
    /// - Returns: 新的建構器實例
    /// - Throws: `NetworkServiceError.encodingFailed` 當 JSON 編碼失敗時
    ///
    /// ## 使用範例
    ///
    /// ```swift
    /// struct SearchRequest: Encodable {
    ///     let keyword: String
    /// }
    ///
    /// let request = SearchRequest(keyword: "Swift")
    /// let builder = try NetworkRequestBuilder()
    ///     .setBody(request)
    /// ```
    func setBody<E>(_ body: E) throws(NetworkServiceError) -> NetworkRequestBuilder where E: Encodable {
        do {
            let data = try JSONEncoder().encode(body)
            return NetworkRequestBuilder(
                baseURL: baseURL,
                stage: stage,
                route: route,
                httpMethod: httpMethod,
                headers: headers,
                queryParams: queryParams,
                bodyData: data,
                timeout: timeout
            )
        } catch {
            throw NetworkServiceError.encodingFailed(encodingError: error as! EncodingError)
        }
    }
    
    /// 設定請求超時時間
    ///
    /// - Parameter timeout: 超時時間（秒）
    /// - Returns: 新的建構器實例
    ///
    /// ## 使用範例
    ///
    /// ```swift
    /// let builder = NetworkRequestBuilder()
    ///     .setTimeout(60) // 60 秒超時
    /// ```
    func setTimeout(_ timeout: TimeInterval) -> NetworkRequestBuilder {
        return NetworkRequestBuilder(
            baseURL: baseURL,
            stage: stage,
            route: route,
            httpMethod: httpMethod,
            headers: headers,
            queryParams: queryParams,
            bodyData: bodyData,
            timeout: timeout
        )
    }
}

// MARK: - Build Method

extension NetworkRequestBuilder {
    
    /// 建立 URLRequest 物件
    ///
    /// 根據建構器中設定的參數建立最終的 `URLRequest`。
    ///
    /// - Returns: 完整配置的 `URLRequest` 物件
    /// - Throws: `NetworkServiceError` 當缺少必要參數或 URL 無效時
    ///
    /// ## 必要參數
    ///
    /// - `baseURL`：必須透過 `setBaseURL(_:)` 設定
    /// - `stage`：必須透過 `setStage(_:)` 設定
    /// - `route`：必須透過 `setRoute(_:)` 設定
    /// - `httpMethod`：必須透過 `setMethod(_:)` 設定
    ///
    /// ## 錯誤處理
    ///
    /// - `NetworkServiceError.invalidURL`：當 URL 建立失敗時拋出
    ///
    /// ## 使用範例
    ///
    /// ```swift
    /// let request = try NetworkRequestBuilder()
    ///     .setBaseURL(NetworkConstants.baseURL)
    ///     .setStage(.default)
    ///     .setRoute(.fetchNews)
    ///     .setMethod(.get)
    ///     .build()
    /// ```
    func build() throws(NetworkServiceError) -> URLRequest {
        // 建立完整的 URL
        guard let url = URL(string: "\(baseURL)\(stage.rawValue)\(route.endpoint)") else {
            throw NetworkServiceError.invalidURL
        }
        
        // 建立 URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.timeoutInterval = timeout
        
        // 設定標頭欄位（合併預設值與用戶設定）
        var finalHeaders = NetworkConfiguration.defaultHeaders
        finalHeaders.merge(headers) { (_, new) in new } // 用戶設定的值會覆蓋預設值
        request.allHTTPHeaderFields = finalHeaders
        
        // 設定請求主體
        if let bodyData = bodyData {
            request.httpBody = bodyData
        }
        
        return request
    }
}
