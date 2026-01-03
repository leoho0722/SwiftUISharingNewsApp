//
//  NewsRequestModel.swift
//  SwiftUISharingNewsAppFinal
//
//  Created by Leo Ho on 2025/11/1.
//

import Foundation

/// 新聞請求
struct NewsRequestModel: Codable {
    
    /// 關鍵字
    let keyword: String?
    
    /// 開始日期
    let startDate: String?
    
    /// 結束日期
    let endDate: String?
    
    enum CodingKeys: String, CodingKey {
        case keyword
        case startDate = "start_date"
        case endDate = "end_date"
    }
    
    /// 預設請求方式，即取得所有新聞資料
    static let `default`: Self = NewsRequestModel(keyword: nil, startDate: nil, endDate: nil)
}
