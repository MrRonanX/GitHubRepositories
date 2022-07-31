//
//  SearchView.swift
//  GitHubRepositories
//
//  Created by Roman Kavinskyi on 7/29/22.
//

import SwiftUI

struct SearchView: View {
    
    @StateObject var viewModel: SearchViewModel
    
    var body: some View {
        VStack {
            SearchField(viewModel: viewModel)
            GeoScroll { _ in
                LazyVStack(alignment: .leading) {
                    ForEach(viewModel.searchResults) { repository in
                        if viewModel.searchResults.last == repository {
                            RepositoryCell(for: repository, parent: .search)
                                .onAppear(perform: viewModel.loadMoreResults)
                            if viewModel.isLoading {
                                bottomProgressView
                            }
                        } else {
                            RepositoryCell(for: repository, parent: .search)
                        }
                    }
                }
            }
        }
        .padding()
        .onTapGesture(perform: hideKeyboard)
        .highPriorityGesture(DragGesture().onChanged { _ in
            hideKeyboard()
        })
        .sheet(item: $viewModel.selectedURL) {
            GRWebView(container: viewModel.container, request: URLRequest(url: $0))
                .interactiveDismissDisabled()
                .edgesIgnoringSafeArea(.bottom)
                .id($0)
        }
    }
    
    private var bottomProgressView: some View {
        VStack {
            Divider()
            HStack {
                Spacer()
                ProgressView()
                Spacer()
            }
            .padding()
        }
    }
}



struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(viewModel: .init(container: DIContainer.preview))
    }
}


