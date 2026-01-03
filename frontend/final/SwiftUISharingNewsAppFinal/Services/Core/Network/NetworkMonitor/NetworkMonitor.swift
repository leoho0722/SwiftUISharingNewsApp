//
//  NetworkMonitor.swift
//  SwiftUISharingNewsAppFinal
//
//  Created by Leo Ho on 2025/12/14.
//

import Foundation
import Network

/// 負責定義網路狀態監控的 Protocol
///
/// 此 Protocol 定義了網路狀態監控所需的核心功能，透過 `NWPathMonitor` 實現網路狀態的即時監聽。
/// 遵循此 Protocol 的類別可以監控裝置的網路連線狀態變化，並透過 `AsyncStream` 回傳網路路徑資訊。
///
/// ## 功能說明
/// - 監控網路連線狀態（如：Wi-Fi、行動網路、無連線等）
/// - 透過非同步串流（AsyncStream）提供即時的網路狀態更新
/// - 支援手動停止監控以釋放系統資源
///
/// ## 使用範例
///
/// ### 基本用法 - 在 ViewModel 中監控網路狀態
/// ```swift
/// @Observable
/// final class MyViewModel {
///     private let networkMonitor: NetworkMonitorProtocol
///
///     init(networkMonitor: NetworkMonitorProtocol = NetworkMonitor()) {
///         self.networkMonitor = networkMonitor
///     }
///
///     var isConnected: Bool {
///         networkMonitor.isConnected
///     }
///
///     func observeNetworkStatus() async {
///         await networkMonitor.start()
///     }
/// }
/// ```
///
/// ### 在 View 中使用
/// ```swift
/// struct ContentView: View {
///     @State private var viewModel = MyViewModel()
///
///     var body: some View {
///         Group {
///             if viewModel.isConnected {
///                 Text("已連線")
///             } else {
///                 Text("網路已中斷")
///             }
///         }
///         .task {
///             await viewModel.observeNetworkStatus()
///         }
///     }
/// }
/// ```
///
/// ## 注意事項
/// - 此 Protocol 繼承自 `AnyObject`，僅限 class 類型遵循
/// - 使用完畢後請呼叫 `stop()` 以避免資源洩漏
/// - 監控會在 `stop()` 被呼叫後自動結束
///
protocol NetworkMonitorProtocol: AnyObject {
    
    /// 目前的網路狀態是否連線
    var isConnected: Bool { get }

    /// 開始監控網路狀態
    /// 
    /// - Note: 當呼叫此方法時，會開始監控網路狀態並持續接收網路路徑更新。直到 `stop()` 被呼叫時，監控將停止。
    @MainActor
    func start() async

    /// 停止監控網路狀態
    ///
    /// - Note: 此方法會取消 `NWPathMonitor` 的監控，並結束相關的 `AsyncStream`。
    /// 建議在不需要監控時呼叫此方法以釋放系統資源。
    func stop()
}

/// 負責定義網路狀態監控的實體類別
///
/// 此類別遵循 `NetworkMonitorProtocol`，並提供網路監控的核心功能。
/// 它使用 `NWPathMonitor` 來監控裝置的網路連線狀態變化，並透過 `AsyncStream` 回傳網路路徑資訊。
///
/// - Note: 此類別標記為 `@Observable` 以支援 SwiftUI 響應式更新，
///         並標記為 `@unchecked Sendable`，因為內部透過專用的 DispatchQueue 確保線程安全。
@Observable
final class NetworkMonitor: @unchecked Sendable {
    
    // MARK: - Properties

    /// 網路狀態監控
    private var monitor: NWPathMonitor?

    /// 網路狀態監控專用線程
    private let queue = DispatchQueue(
        label: "\(Bundle.main.bundleIdentifier!).NetworkMonitor",
        qos: .background
    )

    /// 目前的網路狀態
    private(set) var currentPath: NWPath?

    /// 目前的網路狀態是否連線
    private(set) var isConnected: Bool = false

    // MARK: - Initializer

    /// 當 `NetworkMonitor` 被釋放時，停止監控網路狀態
    deinit {
        stopMonitoring()
    }
}

// MARK: - NetworkMonitorProtocol

extension NetworkMonitor: NetworkMonitorProtocol {
    
    /// 開始監控網路狀態
    /// 
    /// - Note: 當呼叫此方法時，會開始監控網路狀態並持續接收網路路徑更新。直到 `stop()` 被呼叫時，監控將停止。
    @MainActor
    func start() async {
        for await path in startMonitoring() {
            currentPath = path
            isConnected = path.status == .satisfied
        }
    }

    /// 停止監控網路狀態
    func stop() {
        stopMonitoring()
    }
}

// MARK: - Private Methods

private extension NetworkMonitor {
    
    /// 開始監控網路狀態
    /// 
    /// - Returns: 網路監控狀態的 AsyncStream
    func startMonitoring() -> AsyncStream<NWPath> {
        // 先暫停原先的監控
        stopMonitoring()

        // 建立新的監控
        monitor = NWPathMonitor()

        // 建立 AsyncStream
        let (stream, continuation) = AsyncStream.makeStream(of: NWPath.self)
        
        monitor?.pathUpdateHandler = { path in
            continuation.yield(path)
        }
        
        // 開始監控
        monitor?.start(queue: queue)
        
        // 當監控結束時，停止監控
        continuation.onTermination = { @Sendable [weak self] termination in
            guard let self else {
                return
            }
            
            // 只在被取消時才停止監控
            if case .cancelled = termination {
                Task { @MainActor in
                    self.stopMonitoring()
                }
            }
        }
        
        return stream
    }

    /// 停止監控網路狀態
    func stopMonitoring() {
        monitor?.cancel()
        monitor = nil
    }
}
