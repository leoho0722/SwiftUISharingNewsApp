//
//  Button+Extensions.swift
//  SwiftUISharingNewsApp
//
//  Created by Leo Ho on 2025/11/2.
//

import SwiftUI

extension Button where Label : View {
    
    @preconcurrency init(
        asyncAction: @escaping @MainActor () async -> Void,
        @ViewBuilder label: () -> Label
    ) {
        self.init {
            Task { @MainActor in
                await asyncAction()
            }
        } label: {
            label()
        }
    }
}
