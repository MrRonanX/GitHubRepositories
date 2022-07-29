//
//  SearchField.swift
//  GitHubRepositories
//
//  Created by Roman Kavinskyi on 7/29/22.
//

import SwiftUI

struct SearchField: View {
    
    @ObservedObject var viewModel: SearchViewModel
    @FocusState private var focusState: Bool
    
    var body: some View {
        HStack(spacing: 30) {
            ZStack {
                if !viewModel.isSearchFocused && viewModel.searchQuery.isEmpty {
                    HStack {
                        searchImage
                        Text("Search")
                            .lineLimit(1)
                            .foregroundColor(.black)
                    }
                }
                HStack {
                    if viewModel.isSearchFocused || !viewModel.searchQuery.isEmpty {
                        searchImage
                    }
                    
                    TextField("", text: $viewModel.searchQuery)
                        .keyboardType(.webSearch)
                        .focused($focusState)
                        .submitLabel(.search)
                        .autocapitalization(.sentences)
                        .disableAutocorrection(true)
                        .font(.system(size: 17))
                        .foregroundColor(.black)
                        .onChange(of: focusState, perform: focusChanged)
                    
                    if !viewModel.searchQuery.isEmpty {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .onTapGesture(perform: clearTapped)
                    }
                    
                    if viewModel.isSearchFocused && viewModel.searchQuery.isEmpty {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal, 30)
            }
            .frame(height: 60)
            .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.black.opacity(0.25)))
            
            if viewModel.isSearching {
                Button("Close", action: closeTapped)
                    .foregroundColor(Color.white)
            }
        }
        //.animation(.easeIn, value: isFocused)
        //.animation(.easeIn, value: query)
        .animation(.linear(duration: 0.2), value: viewModel.isSearching)
    }
    
    var searchImage: some View {
        Image(systemName: "magnifyingglass")
            .foregroundColor(.black)
    }
    
    private func focusChanged(_ focus: Bool) {
        viewModel.isSearchFocused = focus
    }
    
    private func closeTapped() {
        viewModel.searchQuery = ""
        focusState = false
        viewModel.isSearchFocused = false
        viewModel.isAction = false
        viewModel.endSearching()
    }
    
    private func clearTapped() {
        viewModel.isAction = false
        viewModel.searchQuery = ""
    }
}


struct SearchField_Previews: PreviewProvider {
    static var previews: some View {
        SearchField(viewModel: .init(container: DIContainer.preview))
    }
}

import Combine

final class SearchViewModel: ObservableObject {
    @Published var isSearchFocused = false
    @Published var searchQuery = ""
    
    @Published var isSearching = false
    
    @Published var isAction = false
    
    @Published var searchResults = [Repository]()
    
    let container: DIContainer
    
    var page = 1
    var canLoadMore = true
    
    var cancellables = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
        
        $searchQuery
            .dropFirst()
            .debounce(for: .milliseconds(800), scheduler: RunLoop.main)
            .removeDuplicates()
            .map { query -> String? in
                return query.count < 1 ? nil : query
            }
            .compactMap { $0 }
            .sink { [weak self] query in
                self?.search(with: query)
            }
            .store(in: &cancellables)
        
        container.appState.userData.$repositorySearchResults
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] result in
                self?.handleResults(result)
            }
            .store(in: &cancellables)
            
    }
    
    func handleResults(_ results: RepositoriesSearchResponse) {
        page == 1 ? searchResults = results.items : searchResults.append(contentsOf: results.items)
        canLoadMore = !results.incomplete_results
        page += 1
    }
    
    func endSearching() {
        
    }
    
    func search(with query: String) {
        page = 1
        
        container.services.searchService.searchRepositoryParallel(with: query, page: page)
    }
    
    func loadMoreResults(after cell: Repository) {
        guard searchResults.last == cell, canLoadMore else { return }
        
        container.services.searchService.searchRepositoryParallel(with: searchQuery, page: page)
    }
}

struct RepositoriesSearchResponse: Codable {
    var incomplete_results: Bool
    var items: [Repository]
}

struct Repository: Codable, Identifiable, Equatable {
    let id: Int
    let fullName: String
    let description: String
    let url: String
    let language: String
    let stargazers: Int
    let license: License
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case description
        case url = "html_url"
        case language
        case stargazers = "stargazers_count"
        case license
        case updatedAt = "updated_at"
    }
    
    init(from decoder: Decoder) throws {
        let decoder = try decoder.container(keyedBy: CodingKeys.self)
        id          = try decoder.decodeIfPresent(Int.self, forKey: .id) ?? 0
        fullName    = try decoder.decodeIfPresent(String.self, forKey: .fullName) ?? ""
        description = try decoder.decodeIfPresent(String.self, forKey: .description) ?? ""
        url         = try decoder.decodeIfPresent(String.self, forKey: .url) ?? ""
        language    = try decoder.decodeIfPresent(String.self, forKey: .language) ?? ""
        stargazers  = try decoder.decodeIfPresent(Int.self, forKey: .stargazers) ?? 0
        license     = try decoder.decodeIfPresent(License.self, forKey: .license) ?? License(name: "")
        updatedAt   = try decoder.decodeIfPresent(String.self, forKey: .updatedAt) ?? ""
    }
    
    var licenseName: String {
        license.name
    }
    
    var stars: String {
        stargazers > 1000 ? String(stargazers / 1000) + "k" : String(stargazers)
    }
    
    var lastUpdate: String {
        print(updatedAt)
        return DateTimeUtils.localDateFrom(string: updatedAt)
    }
    
    static func == (lhs: Repository, rhs: Repository) -> Bool {
        lhs.id == rhs.id
    }
}

struct License: Codable {
    let name: String
}
