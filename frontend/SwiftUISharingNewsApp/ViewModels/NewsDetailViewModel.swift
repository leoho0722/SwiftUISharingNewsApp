//
//  NewsDetailViewModel.swift
//  SwiftUISharingNewsApp
//
//  Created by Leo Ho on 2025/11/8.
//

import Foundation

// MARK: - Nested Types

extension NewsDetailViewModel {
    
    /// 支援的檔案副檔名
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
        /// - Parameters:
        ///   - fileExtension: 檔案副檔名
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
    enum SupportedFileType: Equatable {
        
        /// 圖片 (jpg、jpeg、png)
        case image
        
        /// 檔案 (pdf)
        case file
        
        /// 未知
        case unknown

        /// 根據副檔名初始化
        ///
        /// - Parameters:
        ///   - fileExtension: 檔案副檔名
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

/// 新聞詳細內容頁面 ViewModel
final class NewsDetailViewModel {
    
    // MARK: - Properties
    
    
    // MARK: - Initializer
    
    
    // MARK: - Public Methods
    
    /// 是否可以進行檔案預覽
    ///
    /// 目前支援 `jpg`、`jpeg`、`png`、`pdf` 副檔名進行預覽
    ///
    /// - Parameters:
    ///   - fileExtension: 檔案副檔名
    /// - Returns: 包含判斷結果與檔案類型的 tuple (canPreview: Bool, fileType: SupportedFileType)
    func canPreviewFile(_ fileExtension: String) -> (canPreview: Bool, fileType: SupportedFileType) {
        let fileType = SupportedFileType(fileExtension: fileExtension)
        return (fileType.canPreview, fileType)
    }
}
