//
//  NetworkConstants.swift
//  SwiftUISharingNewsApp
//
//  Created by Leo Ho on 2025/11/1.
//

import Foundation

/// 網路服務的常數定義
enum NetworkConstants {
    
    /// 基本的 API URL
    static let baseURL = URL(string: "https://o1tf5cjqzk.execute-api.ap-northeast-1.amazonaws.com")!
    
    /// API 部署環境
    enum APIStage: String {
        
        /// 預設環境 (開發用)
        case `default` = "/default"
    }
    
    /// API 路由
    enum Routes {
        
        /// 取得所有新聞資料
        case fetchNews
        
        /// 根據條件搜尋新聞資料
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
    enum HTTPMethod: String {
        
        case get = "GET"
        
        case post = "POST"
    }
    
    /// HTTP 標頭欄位
    enum HTTPHeaderField: String {
        
        case contentType = "Content-Type"
        
        case authorization = "Authorization"
    }
    
    /// 內容類型
    enum ContentType: String {
        
        /// JSON 格式
        case json = "application/json"
    }
}
