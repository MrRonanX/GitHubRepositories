//
//  SearchViewModel.swift
//  GitHubRepositories
//
//  Created by Roman Kavinskyi on 7/30/22.
//

import SwiftUI
import Combine

final class SearchViewModel: ObservableObject {
    
    @Published var isSearchFocused = false
    @Published var searchQuery = ""
    
    @Published var searchResults = [Repository]()
    @Published var isLoading = false
    @Published var selectedURL: URL?
    
    let container: DIContainer
    
    private var page = 1
    private var canLoadMore = true
    
    private var cancellables = Set<AnyCancellable>()
    
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
        
        NotificationCenter.default.publisher(for: .searchRepositoryTapped)
            .receive(on: RunLoop.main)
            .sink { [weak self] notification in
                self?.handleOpenedRepository(notification)
            }
            .store(in: &cancellables)
    }
    
    private func handleResults(_ results: RepositoriesSearchResponse) {
        page == 1 ? searchResults = results.items : searchResults.append(contentsOf: results.items)
        canLoadMore = !results.incomplete_results
        page += 1
        isLoading = false
    }
    
    private func handleOpenedRepository(_ notification: NotificationCenter.Publisher.Output) {
        guard let userInfo = notification.repositoryData else { return }
        selectedURL = URL(string: userInfo.url)
        saveOpenedRepository(with: userInfo.id)
    }
    
    private func saveOpenedRepository(with id: Int) {
        guard let repo = searchResults.first(where: { $0.id == id }) else { return }
        container.services.persistenceClient.updateHistoryWith(repository: repo)
    }
    
    func endSearching() {
        searchResults = []
    }
    
    private func search(with query: String) {
        page = 1
        
        container.services.searchService.searchRepositoryParallel(with: query, page: page, showLoader: true)
    }
    
    func loadMoreResults() {
        guard canLoadMore else { return }
        isLoading = true
        container.services.searchService.searchRepositoryParallel(with: searchQuery, page: page, showLoader: false)
    }
}
