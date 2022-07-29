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
            GeoScroll { geo in
                VStack(alignment: .leading) {
                    ForEach(viewModel.searchResults) { repository in
                        HStack(alignment: .top) {
                            Image(systemName: "character.book.closed")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .padding(.top, 5)
                            VStack(alignment: .leading) {
                                Text(repository.fullName)
                                    .foregroundColor(.blue)
                                    .font(.system(size: 18))
                                Text(repository.description)
                                    .lineLimit(3)
                                HStack {
                                    HStack {
                                        Image(systemName: "star")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(Color(uiColor: .systemGray))
                                        Text(repository.stars)
                                            .foregroundColor(Color(uiColor: .systemGray))
                                    }
                                    
                                    HStack {
                                        Circle()
                                            .frame(width: 15, height: 15)
                                            .foregroundColor(.green)
                                        Text(repository.language)
                                            .foregroundColor(Color(uiColor: .systemGray))
                                    
                                    }
                                    
                                    Text(repository.licenseName)
                                        .foregroundColor(Color(uiColor: .systemGray))
                                    Text(repository.lastUpdate)
                                        .foregroundColor(Color(uiColor: .systemGray))
                                }
                                .font(.footnote)
                                .lineLimit(1)
                                
                            }
                        }
                        .onAppear { viewModel.loadMoreResults(after: repository)}
                    }
                }
            }
        }
        .padding()
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(viewModel: .init(container: DIContainer.preview))
    }
}
