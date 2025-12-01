//
//  AsyncButton.swift
//  SwiftUISharingNewsApp
//
//  Created by Leo Ho on 2025/11/14.
//

import SwiftUI

/// 封裝 SwiftUI `Button` 的非同步版本，確保 action 於主執行緒上執行並簡化呼叫端的 `Task` 管理
///
/// ### 使用範例
/// ```swift
/// AsyncButton("重新整理最新新聞", symbols: .arrowCounterclockwise) {
///     await viewModel.fetchLatestNews()
/// }
/// ```
struct AsyncButton<Label>: View where Label: View {
    
    // MARK: - View Properties
    
    /// 由呼叫端提供的非同步邏輯，會被強制固定在主執行緒上執行以避免 UI 狀態錯亂
    let action: @MainActor () async -> Void
    
    /// Button 的外觀內容，保持泛型以支援 Text、Label 或自訂複合 View
    let content: () -> Label

    /// 按鈕語意角色，預設為 nil，可選擇性指定以符合不同使用情境
    private(set) var role: ButtonRole? = nil
    
    // MARK: - View Body
    
    /// 透過 `Task` 包裝 action，讓 Button 點擊時自動進入非同步流程
    var body: some View {
        Button(role: role) {
            Task { @MainActor in
                await action()
            }
        } label: {
            content()
        }
    }
}

// MARK: - Initializer

// MARK: 預設初始化

extension AsyncButton {

    /// 最通用的初始化方式，可傳入任何 `View` 作為 Label 並指定需要的非同步動作
    ///
    /// - Parameters:
    ///   - action: 需要綁定在主執行緒執行的非同步邏輯。
    ///   - label: 建構按鈕外觀的 `ViewBuilder`。
    @preconcurrency init(
        action: @escaping @MainActor () async -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.action = action
        self.content = label
    }
}

// MARK: 將 Label 約束為 Text 進行初始化

extension AsyncButton where Label == Text {

    /// 方便 Text 標籤的簡化 overload，直接傳入 i18n key 即可
    ///
    /// - Parameters:
    ///   - titleKey: 要顯示的 `LocalizedStringKey`。
    ///   - action: 需要綁定在主執行緒執行的非同步邏輯。
    @preconcurrency init(
        _ titleKey: LocalizedStringKey,
        action: @escaping @MainActor () async -> Void
    ) {
        self.action = action
        self.content = { Text(titleKey) }
    }
    
    /// 支援 `LocalizedStringResource` 的版本，適合 Swift macro 生成的在地化字串
    ///
    /// - Parameters:
    ///   - titleResource: 要顯示的 `LocalizedStringResource`。
    ///   - action: 需要綁定在主執行緒執行的非同步邏輯。
    @preconcurrency init(
        _ titleResource: LocalizedStringResource,
        action: @escaping @MainActor () async -> Void
    ) {
        self.action = action
        self.content = { Text(titleResource) }
    }
    
    /// 一般字串輸入版本，適合在快速原型或非在地化場景
    ///
    /// - Parameters:
    ///   - title: 要顯示的動態字串內容。
    ///   - action: 需要綁定在主執行緒執行的非同步邏輯。
    @preconcurrency init<S>(
        _ title: S,
        action: @escaping @MainActor () async -> Void
    ) where S: StringProtocol {
        self.action = action
        self.content = { Text(title) }
    }
}

// MARK: 將 Label 約束為 Label<Text, Image> 進行初始化

extension AsyncButton where Label == SwiftUI.Label<Text, Image> {

    /// 與系統 `systemImage` 搭配使用，維持與原生 Button API 一致的呼叫體驗
    ///
    /// - Parameters:
    ///   - titleKey: 要顯示的 `LocalizedStringKey`。
    ///   - systemImage: `SF Symbols` icon 名稱。
    ///   - action: 需要綁定在主執行緒執行的非同步邏輯。
    init(
        _ titleKey: LocalizedStringKey,
        systemImage: String,
        action: @escaping @MainActor () async -> Void
    ) {
        self.action = action
        self.content = { SwiftUI.Label(titleKey, systemImage: systemImage) }
    }
    
    /// 支援 `LocalizedStringResource`，可與 `StringCatalog` 或 `#localized` 等語法搭配
    ///
    /// - Parameters:
    ///   - titleResource: 要顯示的 `LocalizedStringResource`。
    ///   - systemImage: `SF Symbols` icon 名稱。
    ///   - action: 需要綁定在主執行緒執行的非同步邏輯。
    init(
        _ titleResource: LocalizedStringResource,
        systemImage: String,
        action: @escaping @MainActor () async -> Void
    ) {
        self.action = action
        self.content = { SwiftUI.Label(titleResource, systemImage: systemImage) } 
    }
    
    /// 文字來源為任意 `StringProtocol`，用於動態字串場景
    ///
    /// - Parameters:
    ///   - title: 要顯示的動態字串內容。
    ///   - systemImage: `SF Symbols` icon 名稱。
    ///   - action: 需要綁定在主執行緒執行的非同步邏輯。
    init<S>(
        _ title: S,
        systemImage: String,
        action: @escaping @MainActor () async -> Void
    ) where S: StringProtocol {
        self.action = action
        self.content = { SwiftUI.Label(title, systemImage: systemImage) }
    }

    /// 結合自定義 `SFSymbols` 列舉，對應專案中統一管理的 icon 名稱
    ///
    /// - Parameters:
    ///   - titleKey: 要顯示的 `LocalizedStringKey`。
    ///   - symbols: 自訂 `SFSymbols` 列舉，對應統一管理的 icon。
    ///   - action: 需要綁定在主執行緒執行的非同步邏輯。
    init(
        _ titleKey: LocalizedStringKey,
        symbols: SFSymbols,
        action: @escaping @MainActor () async -> Void
    ) {
        self.action = action
        self.content = { SwiftUI.Label(titleKey, symbols: symbols) }
    }
    
    /// `LocalizedStringResource` + `SFSymbols` 的組合
    ///
    /// - Parameters:
    ///   - titleResource: 要顯示的 `LocalizedStringResource`。
    ///   - symbols: 自訂 `SFSymbols` 列舉，對應統一管理的 icon。
    ///   - action: 需要綁定在主執行緒執行的非同步邏輯。
    init(
        _ titleResource: LocalizedStringResource,
        symbols: SFSymbols,
        action: @escaping @MainActor () async -> Void
    ) {
        self.action = action
        self.content = { SwiftUI.Label(titleResource, symbols: symbols) } 
    }
    
    /// 動態字串場景下，仍可沿用 `SFSymbols` 的統一對應方式
    ///
    /// - Parameters:
    ///   - title: 要顯示的動態字串內容。
    ///   - symbols: 自訂 `SFSymbols` 列舉，對應統一管理的 icon。
    ///   - action: 需要綁定在主執行緒執行的非同步邏輯。
    init<S>(
        _ title: S,
        symbols: SFSymbols,
        action: @escaping @MainActor () async -> Void
    ) where S: StringProtocol {
        self.action = action
        self.content = { SwiftUI.Label(title, symbols: symbols) }
    }
    
    /// 使用 Xcode Catalog 生成的 `ImageResource`，避免硬編碼資源名稱
    ///
    /// - Parameters:
    ///   - titleKey: 要顯示的 `LocalizedStringKey`。
    ///   - image: 由 Asset Catalog 生成的 `ImageResource`。
    ///   - action: 需要綁定在主執行緒執行的非同步邏輯。
    @preconcurrency init(
        _ titleKey: LocalizedStringKey,
        image: ImageResource,
        action: @escaping @MainActor () async -> Void
    ) {
        self.action = action
        self.content = { SwiftUI.Label(titleKey, image: image) }
    }
    
    /// `LocalizedStringResource` + `ImageResource` 組合
    ///
    /// - Parameters:
    ///   - titleResource: 要顯示的 `LocalizedStringResource`。
    ///   - image: 由 Asset Catalog 生成的 `ImageResource`。
    ///   - action: 需要綁定在主執行緒執行的非同步邏輯。
    @preconcurrency init(
        _ titleResource: LocalizedStringResource,
        image: ImageResource,
        action: @escaping @MainActor () async -> Void
    ) {
        self.action = action
        self.content = { SwiftUI.Label(titleResource, image: image) }
    }
    
    /// 一般字串 + `ImageResource` 的版本，讓外部貼近原生 `Label` API
    ///
    /// - Parameters:
    ///   - title: 要顯示的動態字串內容。
    ///   - image: 由 Asset Catalog 生成的 `ImageResource`。
    ///   - action: 需要綁定在主執行緒執行的非同步邏輯。
    @preconcurrency init<S>(
        _ title: S,
        image: ImageResource,
        action: @escaping @MainActor () async -> Void
    ) where S: StringProtocol {
        self.action = action
        self.content = { SwiftUI.Label(title, image: image) }
    }
}

// MARK: 使用 ButtonRole 進行初始化

extension AsyncButton {
    
    /// 如需指定 `ButtonRole` (ex: .destructive) 可使用此組合，其他行為與預設初始化相同
    ///
    /// - Parameters:
    ///   - role: 按鈕語意角色，例如 `.destructive` 或 `.cancel`。
    ///   - action: 需要綁定在主執行緒執行的非同步邏輯。
    ///   - label: 建構按鈕外觀的 `ViewBuilder`。
    @preconcurrency init(
        role: ButtonRole?,
        action: @escaping @MainActor () async -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.action = action
        self.content = label
        self.role = role
    }
}

// MARK: 使用 ButtonRole 且 Label 約束為 Text 進行初始化

extension AsyncButton where Label == Text {

    /// Text + Role 的常見組合，利於建構破壞性按鈕或取消按鈕
    ///
    /// - Parameters:
    ///   - role: 按鈕語意角色，例如 `.destructive` 或 `.cancel`。
    ///   - titleKey: 要顯示的 `LocalizedStringKey`。
    ///   - action: 需要綁定在主執行緒執行的非同步邏輯。
    @preconcurrency init(
        role: ButtonRole?,
        _ titleKey: LocalizedStringKey,
        action: @escaping @MainActor () async -> Void
    ) {
        self.action = action
        self.content = { Text(titleKey) }
        self.role = role
    }
    
    /// `LocalizedStringResource` 版本，適用於 `String Catalog` 管理文字的專案
    ///
    /// - Parameters:
    ///   - role: 按鈕語意角色，例如 `.destructive` 或 `.cancel`。
    ///   - titleResource: 要顯示的 `LocalizedStringResource`。
    ///   - action: 需要綁定在主執行緒執行的非同步邏輯。
    @preconcurrency init(
        role: ButtonRole?,
        _ titleResource: LocalizedStringResource,
        action: @escaping @MainActor () async -> Void
    ) {
        self.action = action
        self.content = { Text(titleResource) }
        self.role = role
    }
    
    /// 字串版 Role API，常見於動態顯示的文字內容
    ///
    /// - Parameters:
    ///   - role: 按鈕語意角色，例如 `.destructive` 或 `.cancel`。
    ///   - title: 要顯示的動態字串內容。
    ///   - action: 需要綁定在主執行緒執行的非同步邏輯。
    @preconcurrency init<S>(
        role: ButtonRole?,
        _ title: S,
        action: @escaping @MainActor () async -> Void
    ) where S: StringProtocol {
        self.action = action
        self.content = { Text(title) }
        self.role = role
    }
}

// MARK: 使用 ButtonRole 且 Label 約束為 Label<Text, Image> 進行初始化

extension AsyncButton where Label == SwiftUI.Label<Text, Image> {

    /// 提供 `ButtonRole` 與 `systemImage` 的組合，方便快速建立具語義的 icon 按鈕
    ///
    /// - Parameters:
    ///   - role: 按鈕語意角色，例如 `.destructive` 或 `.cancel`。
    ///   - titleKey: 要顯示的 `LocalizedStringKey`。
    ///   - systemImage: `SF Symbols` icon 名稱。
    ///   - action: 需要綁定在主執行緒執行的非同步邏輯。
    init(
        role: ButtonRole?,
        _ titleKey: LocalizedStringKey,
        systemImage: String,
        action: @escaping @MainActor () async -> Void
    ) {
        self.action = action
        self.content = { SwiftUI.Label(titleKey, systemImage: systemImage) }
        self.role = role
    }
    
    /// 與 `LocalizedStringResource` 串接的 icon 版本
    ///
    /// - Parameters:
    ///   - role: 按鈕語意角色，例如 `.destructive` 或 `.cancel`。
    ///   - titleResource: 要顯示的 `LocalizedStringResource`。
    ///   - systemImage: `SF Symbols` icon 名稱。
    ///   - action: 需要綁定在主執行緒執行的非同步邏輯。
    init(
        role: ButtonRole?,
        _ titleResource: LocalizedStringResource,
        systemImage: String,
        action: @escaping @MainActor () async -> Void
    ) {
        self.action = action
        self.content = { SwiftUI.Label(titleResource, systemImage: systemImage) } 
        self.role = role
    }
    
    init<S>(
        role: ButtonRole?,
        _ title: S,
        systemImage: String,
        action: @escaping @MainActor () async -> Void
    ) where S: StringProtocol {
        self.action = action
        self.content = { SwiftUI.Label(title, systemImage: systemImage) }
        self.role = role
    }
    
    /// Role + `SFSymbols` 的版本，維持 icon 管理的一致性
    ///
    /// - Parameters:
    ///   - role: 按鈕語意角色，例如 `.destructive` 或 `.cancel`。
    ///   - titleKey: 要顯示的 `LocalizedStringKey`。
    ///   - symbols: 自訂 `SFSymbols` 列舉，對應統一管理的 icon。
    ///   - action: 需要綁定在主執行緒執行的非同步邏輯。
    init(
        role: ButtonRole?,
        _ titleKey: LocalizedStringKey,
        symbols: SFSymbols,
        action: @escaping @MainActor () async -> Void
    ) {
        self.action = action
        self.content = { SwiftUI.Label(titleKey, symbols: symbols) }
        self.role = role
    }
    
    /// `LocalizedStringResource` + `SFSymbols` 組合
    ///
    /// - Parameters:
    ///   - role: 按鈕語意角色，例如 `.destructive` 或 `.cancel`。
    ///   - titleResource: 要顯示的 `LocalizedStringResource`。
    ///   - symbols: 自訂 `SFSymbols` 列舉，對應統一管理的 icon。
    ///   - action: 需要綁定在主執行緒執行的非同步邏輯。
    init(
        role: ButtonRole?,
        _ titleResource: LocalizedStringResource,
        symbols: SFSymbols,
        action: @escaping @MainActor () async -> Void
    ) {
        self.action = action
        self.content = { SwiftUI.Label(titleResource, symbols: symbols) }
        self.role = role
    }
    
    /// 動態字串 + `SFSymbols` 的 Role 版本，維持 icon 管理一致性
    ///
    /// - Parameters:
    ///   - role: 按鈕語意角色，例如 `.destructive` 或 `.cancel`。
    ///   - title: 要顯示的動態字串內容。
    ///   - symbols: 自訂 `SFSymbols` 列舉，對應統一管理的 icon。
    ///   - action: 需要綁定在主執行緒執行的非同步邏輯。
    init<S>(
        role: ButtonRole?,
        _ title: S,
        symbols: SFSymbols,
        action: @escaping @MainActor () async -> Void
    ) where S: StringProtocol {
        self.action = action
        self.content = { SwiftUI.Label(title, symbols: symbols) }
        self.role = role
    }

    /// Role + `ImageResource`，通常搭配 Asset Catalog 中的客製化圖示
    ///
    /// - Parameters:
    ///   - role: 按鈕語意角色，例如 `.destructive` 或 `.cancel`。
    ///   - titleKey: 要顯示的 `LocalizedStringKey`。
    ///   - image: 由 Asset Catalog 生成的 `ImageResource`。
    ///   - action: 需要綁定在主執行緒執行的非同步邏輯。
    @preconcurrency init(
        role: ButtonRole?,
        _ titleKey: LocalizedStringKey,
        image: ImageResource,
        action: @escaping @MainActor () async -> Void
    ) {
        self.action = action
        self.content = { SwiftUI.Label(titleKey, image: image) }
        self.role = role
    }
    
    /// `LocalizedStringResource` + `ImageResource` 搭配
    ///
    /// - Parameters:
    ///   - role: 按鈕語意角色，例如 `.destructive` 或 `.cancel`。
    ///   - titleResource: 要顯示的 `LocalizedStringResource`。
    ///   - image: 由 Asset Catalog 生成的 `ImageResource`。
    ///   - action: 需要綁定在主執行緒執行的非同步邏輯。
    @preconcurrency init(
        role: ButtonRole?,
        _ titleResource: LocalizedStringResource,
        image: ImageResource,
        action: @escaping @MainActor () async -> Void
    ) {
        self.action = action
        self.content = { SwiftUI.Label(titleResource, image: image) }
        self.role = role
    }
    
    /// 動態字串 + `ImageResource` 的版本
    ///
    /// - Parameters:
    ///   - role: 按鈕語意角色，例如 `.destructive` 或 `.cancel`。
    ///   - title: 要顯示的動態字串內容。
    ///   - image: 由 Asset Catalog 生成的 `ImageResource`。
    ///   - action: 需要綁定在主執行緒執行的非同步邏輯。
    @preconcurrency init<S>(
        role: ButtonRole?,
        _ title: S,
        image: ImageResource,
        action: @escaping @MainActor () async -> Void
    ) where S: StringProtocol {
        self.action = action
        self.content = { SwiftUI.Label(title, image: image) }
        self.role = role
    }
}

// MARK: - Preview

#Preview {
    AsyncButton {
        
    } label: {
        
    }
}
