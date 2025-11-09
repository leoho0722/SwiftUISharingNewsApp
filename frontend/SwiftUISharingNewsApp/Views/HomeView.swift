//
//  HomeView.swift
//  SwiftUISharingNewsApp
//
//  Created by Leo Ho on 2025/11/4.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            Tab {
                NewsListView()
            } label: {
                Label("新聞列表", symbols: .newspaperFill)
            }
            
            Tab {
                SearchNewsView()
            } label: {
                Label("新聞搜尋", symbols: .magnifyingglass)
            }
        }
    }
}

#Preview {
    HomeView()
}
