//
//  SearchService.swift
//  GitHubRepositories
//
//  Created by Roman Kavinskyi on 7/29/22.
//

import Foundation

protocol SearchService {
    func searchRepositoryParallel(with: String, page: Int, showLoader: Bool)
}

struct RemoteSearchService: AppService, SearchService {
    
    let appState: AppState
    let searchClient: SearchClient
    
    func searchRepositoryParallel(with query: String, page: Int, showLoader: Bool) {
        multipleRequests(showLoader: showLoader) {
            [
                await searchClient.searchRepositories(with: query, page: page),
                await searchClient.searchRepositories(with: query, page: page + 1)
            ]

        } resultHandler: { result in
            guard case let .success(response) = result else { return }
            appState.userData.repositorySearchResults = response
        }
    }
}

struct StubSearchService: SearchService {
    func searchRepositoryParallel(with: String, page: Int, showLoader: Bool) {}
}

