//
//  AuthService.swift
//  GitHubRepositories
//
//  Created by Roman Kavinskyi on 7/29/22.
//

import Foundation

protocol AuthService {
    func authCodeRequest() -> URLRequest
    func authTokenRequest(with: String)
}

struct RemoteAuthService: AppService, AuthService {
    let appState: AppState
    let loginClient: LoginClient
    
    func authCodeRequest() -> URLRequest {
        return loginClient.authCodeRequest()
    }
    
    func authTokenRequest(with code: String) {
        request {
            await loginClient.authTokenRequest(with: code)
        } resultHandler: { (result: Result<AuthResponse, APIError>) in
            switch result {
            case .success(let response):
                appState.token = response.token
                
            case .failure(let failure):
                appState.alert(body: failure.localizedDescription)
            }
        }
    }
}

struct StubAuthService: AuthService {
    func authTokenRequest(with: String) { }
    
    func authCodeRequest() -> URLRequest {
        return try! RemoteLoginClient.API.authCodeRequest.asURLRequest()
    }
}




