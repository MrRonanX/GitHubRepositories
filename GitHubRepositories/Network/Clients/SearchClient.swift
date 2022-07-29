//
//  SearchClient.swift
//  GitHubRepositories
//
//  Created by Roman Kavinskyi on 7/29/22.
//

import Foundation

protocol SearchClient: APIClient {
    typealias SearchResponse = Result<RepositoriesSearchResponse, APIError>
    
    func searchRepositories(with: String, page: Int) async -> SearchResponse
}


struct RemoteSearchClient: SearchClient {
    
    var session: URLSession
    
    func searchRepositories(with query: String, page: Int) async -> SearchResponse {
        return await request(API.searchRepositories(query: query, page: page))
        
    }
}

extension RemoteSearchClient {
    enum API {
        case searchRepositories(query: String, page: Int)
    }
}

extension RemoteSearchClient.API: APIRequest {
    
    var path: String {
        switch self {
        case .searchRepositories: return APIEndpoint.Search.searchRepositories.rawValue
        }
    }
    
    var method: HTTPMethod { .get }
    var contentType: ContentType { .json }
    
    var params: RequestParams {
        switch self {
        case .searchRepositories(let query, let page):
            return .query([
                "q": query,
                "sort": "stars",
                "order": "desc",
                "per_page": 15,
                "page": page
            ])
        }
    }
}
