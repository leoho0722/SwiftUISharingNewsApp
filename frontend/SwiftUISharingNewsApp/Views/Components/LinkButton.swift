//
//  LinkButton.swift
//  SwiftUISharingNewsApp
//
//  Created by Leo Ho on 2025/11/9.
//

import SwiftUI

struct LinkButton: View {
    
    // MARK: - View Properties
    
    /// Link 標題
    let title: String
    
    /// Link icon (SF Symbols)
    let symbols: SFSymbols
    
    /// Link URL
    let url: URL
    
    @Environment(\.openURL) private var openURL
    
    // MARK: - View Body
    
    var body: some View {
        Button {
            openURL(url)
        } label: {
            Label(title, symbols: symbols)
                .padding(5)
        }
    }
}

// MARK: - Previews

#Preview {
    LinkButton(
        title: "檔案連結",
        symbols: .link,
        url: URL(string: "https://www.apple.com")!
    )
}
