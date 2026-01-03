//
//  NetworkMonitor+Environment.swift
//  SwiftUISharingNewsAppStarter
//
//  Created by Leo Ho on 2025/12/14.
//

import Foundation
import SwiftUI

/// 定義 NetworkMonitor 在 SwiftUI Environment 中的 Key
struct NetworkMonitorKey: EnvironmentKey {
    
    /// 定義 Value 類型為 NetworkMonitorProtocol，以支援依賴注入
    typealias Value = NetworkMonitorProtocol
    
    /// 預設值為 NetworkMonitor 實例
    static let defaultValue: NetworkMonitorProtocol = NetworkMonitor()
}

// MARK: - EnvironmentValues Extension

extension EnvironmentValues {
    
    /// 透過 Environment 存取 NetworkMonitor
    ///
    /// ## 使用方式
    /// ```swift
    /// struct ContentView: View {
    /// 
    ///     @Environment(\.networkMonitor) private var networkMonitor
    ///     
    ///     var body: some View {
    ///         Text(networkMonitor.isConnected ? "已連線" : "未連線")
    ///     }
    /// }
    /// ```
    var networkMonitor: NetworkMonitorProtocol {
        get { self[NetworkMonitorKey.self] }
        set { self[NetworkMonitorKey.self] = newValue }
    }
}
