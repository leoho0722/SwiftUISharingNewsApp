//
//  NewsDetailViewModel.swift
//  SwiftUISharingNewsAppFinal
//
//  Created by Leo Ho on 2025/11/8.
//

import Foundation

/// 新聞詳細內容頁面 ViewModel
final class NewsDetailViewModel {
    
    // MARK: - Properties
    
    
    // MARK: - Init
    
}

// MARK: - Nested Types

extension NewsDetailViewModel {
    
    /// 支援的檔案副檔名
    /// 
    /// - jpg, jpeg：JPG、JPEG
    /// - png：PNG
    /// - pdf：PDF
    /// - unsupported：未支援
    enum SupportedFileExtension: CaseIterable {
        
        /// JPG、JPEG
        case jpg, jpeg
        
        /// PNG
        case png
        
        /// PDF
        case pdf
        
        /// 未支援
        case unsupported
        
        /// 根據副檔名初始化
        ///
        /// - Parameter fileExtension: 檔案副檔名
        init(fileExtension: String) {
            let lowercased = fileExtension.lowercased()
            switch lowercased {
            case "jpg":
                self = .jpg
            case "jpeg":
                self = .jpeg
            case "png":
                self = .png
            case "pdf":
                self = .pdf
            default:
                self = .unsupported
            }
        }
    }
    
    /// 支援的檔案種類
    /// 
    /// - image：圖片 (jpg、jpeg、png)
    /// - file：檔案 (pdf)
    /// - unknown：未知
    enum SupportedFileType: Equatable {
        
        /// 圖片 (jpg、jpeg、png)
        case image
        
        /// 檔案 (pdf)
        case file
        
        /// 未知
        case unknown
        
        /// 根據副檔名初始化
        ///
        /// - Parameter fileExtension: 檔案副檔名
        init(fileExtension: String) {
            let fileExt = SupportedFileExtension(fileExtension: fileExtension)
            switch fileExt {
            case .jpg, .jpeg, .png:
                self = .image
            case .pdf:
                self = .file
            case .unsupported:
                self = .unknown
            }
        }
        
        /// 是否可以預覽
        var canPreview: Bool {
            return self != .unknown
        }
    }
}

// MARK: - Internal Method

extension NewsDetailViewModel {
    
    /// 判斷是否可以預覽檔案
    ///
    /// - Parameter fileExtension: 檔案副檔名
    /// - Returns: 是否可以預覽及檔案類型
    func canPreviewFile(_ fileExtension: String) -> (canPreview: Bool, fileType: SupportedFileType) {
        let fileType = SupportedFileType(fileExtension: fileExtension)
        return (fileType.canPreview, fileType)
    }
}