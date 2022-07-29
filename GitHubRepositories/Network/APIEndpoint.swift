//
//  APIEndpoint.swift
//  GitHubRepositories
//
//  Created by Roman Kavinskyi on 7/29/22.
//

import Foundation

enum APIEndpoint {
    enum Base: String {
        case auth               = "https://github.com"
        case base               = "https://api.github.com"
        
    }
    
    enum Auth: String {
        case authCodeRequest    = "/login/oauth/authorize"
        case authTokenRequest   = "/login/oauth/access_token"
    }
    
    enum Search: String {
        case searchRepositories = "/search/repositories"
    }
}
