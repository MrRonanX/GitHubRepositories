//
//  LoginClient.swift
//  GitHubRepositories
//
//  Created by Roman Kavinskyi on 7/29/22.
//

import Foundation

protocol LoginClient: APIClient {
    typealias LoginResponse = Result<AuthResponse, APIError>
    
    func authCodeRequest() -> URLRequest
    func authTokenRequest(with code: String) async -> LoginResponse
}

struct RemoteLoginClient: LoginClient {
    
    var session: URLSession
    
    func authCodeRequest() -> URLRequest {
        return try! API.authCodeRequest.asURLRequest()
    }
    
    func authTokenRequest(with code: String) async -> LoginResponse {
        return await request(API.authTokenRequest(code: code))
    }
}


extension RemoteLoginClient {
    enum API {
        case authCodeRequest
        case authTokenRequest(code: String)
    }
}

extension RemoteLoginClient.API: APIRequest {
    
    var baseURL: String { APIEndpoint.Base.auth.rawValue }
    
    var path: String {
        switch self {
        case .authCodeRequest: return APIEndpoint.Auth.authCodeRequest.rawValue
        case .authTokenRequest: return APIEndpoint.Auth.authTokenRequest.rawValue
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .authCodeRequest: return .get
        case .authTokenRequest: return .post
        }
    }
    var contentType: ContentType { .json }
    
    var params: RequestParams {
        switch self {
        case .authCodeRequest:
            return .query([
                "client_id": GitHubKeys.clientID,
                "scope": GitHubKeys.scope,
                "redirect_uri": GitHubKeys.redirectUrl,
                "state": UUID().uuidString
            ])
        case .authTokenRequest(let code):
            
            return .body([
                "grant_type": "authorization_code",
                "code": code,
                "client_id": GitHubKeys.clientID,
                "client_secret": GitHubKeys.clientSecret
            ])
        }
    }
}


