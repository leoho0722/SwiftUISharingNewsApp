//
//  NewsDetailViewModelTests.swift
//  SwiftUISharingNewsAppStarterTests
//
//  Created by Leo Ho on 2025/12/5.
//

import Testing
@testable import SwiftUISharingNewsAppStarter

/// NewsDetailViewModel 單元測試
///
/// 使用 GWT (Given-When-Then) 風格撰寫，測試檔案預覽支援判斷邏輯。
@Suite("NewsDetailViewModel 測試")
struct NewsDetailViewModelTests {
    
    // MARK: - Properties
    
    private let viewModel = NewsDetailViewModel()
    
    // MARK: - 圖片預覽測試
    
    @Test("給定副檔名為 jpg，當呼叫 canPreviewFile 時，則 canPreview 為 true 且 fileType 為 image")
    func canPreviewFile_withJPG_shouldReturnImageType() {
        // Given
        let fileExtension = "jpg"
        
        // When
        let result = viewModel.canPreviewFile(fileExtension)
        
        // Then
        #expect(result.canPreview == true)
        #expect(result.fileType == .image)
    }
    
    @Test("給定副檔名為 jpeg，當呼叫 canPreviewFile 時，則 canPreview 為 true 且 fileType 為 image")
    func canPreviewFile_withJPEG_shouldReturnImageType() {
        // Given
        let fileExtension = "jpeg"
        
        // When
        let result = viewModel.canPreviewFile(fileExtension)
        
        // Then
        #expect(result.canPreview == true)
        #expect(result.fileType == .image)
    }
    
    @Test("給定副檔名為 png，當呼叫 canPreviewFile 時，則 canPreview 為 true 且 fileType 為 image")
    func canPreviewFile_withPNG_shouldReturnImageType() {
        // Given
        let fileExtension = "png"
        
        // When
        let result = viewModel.canPreviewFile(fileExtension)
        
        // Then
        #expect(result.canPreview == true)
        #expect(result.fileType == .image)
    }
    
    // MARK: - PDF 預覽測試
    
    @Test("給定副檔名為 pdf，當呼叫 canPreviewFile 時，則 canPreview 為 true 且 fileType 為 file")
    func canPreviewFile_withPDF_shouldReturnFileType() {
        // Given
        let fileExtension = "pdf"
        
        // When
        let result = viewModel.canPreviewFile(fileExtension)
        
        // Then
        #expect(result.canPreview == true)
        #expect(result.fileType == .file)
    }
    
    // MARK: - 大寫副檔名測試
    
    @Test("給定副檔名為大寫 JPG，當呼叫 canPreviewFile 時，則仍能正確識別為 image")
    func canPreviewFile_withUppercaseJPG_shouldReturnImageType() {
        // Given
        let fileExtension = "JPG"
        
        // When
        let result = viewModel.canPreviewFile(fileExtension)
        
        // Then
        #expect(result.canPreview == true)
        #expect(result.fileType == .image)
    }
    
    @Test("給定副檔名為大寫 PDF，當呼叫 canPreviewFile 時，則仍能正確識別為 file")
    func canPreviewFile_withUppercasePDF_shouldReturnFileType() {
        // Given
        let fileExtension = "PDF"
        
        // When
        let result = viewModel.canPreviewFile(fileExtension)
        
        // Then
        #expect(result.canPreview == true)
        #expect(result.fileType == .file)
    }
    
    // MARK: - 不支援格式測試
    
    @Test("給定副檔名為 doc，當呼叫 canPreviewFile 時，則 canPreview 為 false 且 fileType 為 unknown")
    func canPreviewFile_withDOC_shouldReturnUnknownType() {
        // Given
        let fileExtension = "doc"
        
        // When
        let result = viewModel.canPreviewFile(fileExtension)
        
        // Then
        #expect(result.canPreview == false)
        #expect(result.fileType == .unknown)
    }
    
    @Test("給定副檔名為 xlsx，當呼叫 canPreviewFile 時，則 canPreview 為 false 且 fileType 為 unknown")
    func canPreviewFile_withXLSX_shouldReturnUnknownType() {
        // Given
        let fileExtension = "xlsx"
        
        // When
        let result = viewModel.canPreviewFile(fileExtension)
        
        // Then
        #expect(result.canPreview == false)
        #expect(result.fileType == .unknown)
    }
    
    @Test("給定副檔名為空字串，當呼叫 canPreviewFile 時，則 canPreview 為 false 且 fileType 為 unknown")
    func canPreviewFile_withEmptyString_shouldReturnUnknownType() {
        // Given
        let fileExtension = ""
        
        // When
        let result = viewModel.canPreviewFile(fileExtension)
        
        // Then
        #expect(result.canPreview == false)
        #expect(result.fileType == .unknown)
    }
}
