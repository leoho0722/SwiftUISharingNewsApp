//
//  NetworkErrorView.swift
//  SwiftUISharingNewsAppStarter
//
//  Created by Leo Ho on 2025/12/14.
//

import SwiftUI

/// 網路狀態錯誤畫面
struct NetworkErrorView: View {
    
    // MARK: - View Properties
    
    
    // MARK: - View Body
    
    var body: some View {
        ErrorView {
            Label("網路狀態異常！", symbols: .wifiSlash)
        } actions: {
            LinkButton(
                title: "前往 Wi-Fi 設定",
                symbols: .gearCircle,
                url: .systemWIFI
            )
            .padding()
        }
    }
}

// MARK: - Preview

#Preview {
    NetworkErrorView()
}
