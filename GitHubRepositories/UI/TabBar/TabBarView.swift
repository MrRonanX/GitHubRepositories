//
//  TabBarView.swift
//  GitHubRepositories
//
//  Created by Roman Kavinskyi on 7/29/22.
//

import SwiftUI

struct TabBarView: View {
    
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        TabView {
            SearchView(viewModel: .init(container: viewModel.container))
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            
            HistoryView(viewModel: .init(viewModel.container))
                .tabItem {
                    Label("History", systemImage: "books.vertical")
                }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(viewModel: .init(container: .preview))
    }
}


