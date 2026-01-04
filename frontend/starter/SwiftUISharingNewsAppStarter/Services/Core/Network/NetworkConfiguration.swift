//
//  NetworkConfiguration.swift
//  SwiftUISharingNewsAppStarter
//
//  Created by Leo Ho on 2026/1/4.
//

import Foundation

/// 網路服務配置
struct NetworkConfiguration {
    
    /// 基本的 API URL
    let baseURL: URL

    /// API 部署環境
    let stage: APIStage
    
    /// API 路由
    let routes: Routes
    
    /// HTTP 方法
    let httpMethod: HTTPMethod
    
    /// HTTP 標頭欄位
    let httpHeaderField: HTTPHeaderField
    
    /// 內容類型
    let contentType: ContentType
}

// MARK: - Nested Types

extension NetworkConfiguration {
    
    /// API 部署環境
    /// 
    /// - default：預設環境 (開發用)
    enum APIStage: String {
        
        /// 預設環境 (開發用)
        case `default` = "/default"
    }
    
    /// API 路由
    /// 
    /// - fetchNews：取得所有新聞資料 (GET)
    /// - searchNews：根據條件搜尋新聞資料 (POST)
    enum Routes {
        
        /// 取得所有新聞資料 (GET)
        case fetchNews
        
        /// 根據條件搜尋新聞資料 (POST)
        case searchNews
        
        /// API Endpoint
        var endpoint: String {
            switch self {
            case .fetchNews: return "/news"
            case .searchNews: return "/searchNews"
            }
        }
    }
    
    /// HTTP 方法
    /// 
    /// - get：GET 方法
    /// - post：POST 方法
    enum HTTPMethod: String {
        
        /// GET 方法
        case get = "GET"
        
        /// POST 方法
        case post = "POST"
    }
    
    /// HTTP 標頭欄位
    /// 
    /// - contentType：內容類型
    /// - authorization：授權
    enum HTTPHeaderField: String {
        
        /// 內容類型
        case contentType = "Content-Type"
        
        /// 授權
        case authorization = "Authorization"
    }
    
    /// 內容類型
    /// 
    /// - json：JSON 格式
    /// - formURLEncoded：表單 URL 編碼格式
    /// - formData：多部分表單資料格式
    /// - plainText：純文字格式
    /// - xml：XML 格式
    enum ContentType: String {
        
        /// JSON 格式
        case json = "application/json"
        
        /// 表單 URL 編碼格式
        case formURLEncoded = "application/x-www-form-urlencoded"
        
        /// 多部分表單資料格式
        case formData = "multipart/form-data"
        
        /// 純文字格式
        case plainText = "text/plain"
        
        /// XML 格式
        case xml = "application/xml"
    }
    
    /// 授權類型
    ///
    /// - bearer：Bearer Token 授權
    /// - basic：基本授權（使用者名稱和密碼）
    /// - apiKey：API Key 授權
    enum AuthorizationType {
        
        /// Bearer Token 授權
        /// 
        /// - Parameter token: Bearer Token
        case bearer(String)
        
        /// 基本授權（使用者名稱和密碼）
        /// 
        /// - Parameters:
        ///   - username: 使用者名稱
        ///   - password: 使用者密碼
        case basic(username: String, password: String)
        
        /// API Key 授權
        /// 
        /// - Parameter apiKey: API Key
        case apiKey(String)
        
        /// 取得 Authorization header 的值
        var headerValue: String {
            switch self {
            case .bearer(let token):
                return "Bearer \(token)"
            case .basic(let username, let password):
                let credentials = "\(username):\(password)"
                let encoded = Data(credentials.utf8).base64EncodedString()
                return "Basic \(encoded)"
            case .apiKey(let apiKey):
                return apiKey
            }
        }
    }
}

// MARK: - Default Configuration

extension NetworkConfiguration {
    
    /// 預設的 HTTP 標頭欄位
    ///
    /// 提供預設的 HTTP 標頭欄位配置，包含 Content-Type 為 application/json。
    /// 在建立請求時，這些預設值會被自動應用，除非被明確覆蓋。
    ///
    /// - Returns: 預設標頭欄位的字典
    static var defaultHeaders: [String : String] {
        return [
            HTTPHeaderField.contentType.rawValue : ContentType.json.rawValue
        ]
    }
}
