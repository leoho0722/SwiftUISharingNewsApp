//
//  View+Extensions.swift
//  SwiftUISharingNewsApp
//
//  Created by Leo Ho on 2025/11/14.
//

import SwiftUI

extension View {
    
    /// 利用 `Task` 將同步的 `onSubmit` 轉為可呼叫 async 作業，避免在閉包中違反 actor 隔離規則。
    /// 當 `asyncAction` 所屬對象被標記為 `@MainActor` 或其他 actor 時，可藉此安全地觸發非同步邏輯。
    ///
    /// - Parameters:
    ///   - triggers: 觸發 `onSubmit` 的條件，預設為 `.text`。
    ///   - asyncAction: 需在提交時執行的非同步任務。
    ///
    /// 使用範例：
    /// ```swift
    /// TextField("關鍵字", text: $query)
    ///     .submitLabel(.search)
    ///     .onSubmit {
    ///         await viewModel.fetchNews(keyword: query)
    ///     }
    /// ```
    nonisolated func onSubmit(
        of triggers: SubmitTriggers = .text,
        _ asyncAction: @escaping () async -> Void
    ) -> some View {
        onSubmit(of: triggers) {
            Task {
                await asyncAction()
            }
        }
    }
}
