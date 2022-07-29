//
//  AppService.swift
//  GitHubRepositories
//
//  Created by Roman Kavinskyi on 7/29/22.
//

import Foundation

protocol AppService {
    var appState: AppState { get }
}

extension AppService {
    func request<D: Decodable, E: Error>(
        showLoader: Bool = false,
        clientResult: @escaping () async -> Result<D,E>,
        resultHandler: @escaping (Result<D,E>) -> Void)
    {
        Task {
            if showLoader { appState.isLoading = true }
            let result = await clientResult()
            if showLoader { appState.isLoading = false }

//                if case let .failure(error) = result,
//                   let apiError = error as? APIError,
//                   case let .unauthorized(message) = apiError,
//                   message == BackendErrors.unauthenticated {
//                    appState.logout()
//                    return
//                }
            
            resultHandler(result)
        }
    }
    
    func multipleRequests<D: Decodable, E: Error>(
        showLoader: Bool = false,
        clientResult: @escaping () async -> [Result<D,E>],
        resultHandler: @escaping (Result<D,E>) -> Void)
    {
        Task {
            if showLoader { appState.isLoading = true }
            let results = await clientResult()
            if showLoader { appState.isLoading = false }

//                if case let .failure(error) = result,
//                   let apiError = error as? APIError,
//                   case let .unauthorized(message) = apiError,
//                   message == BackendErrors.unauthenticated {
//                    appState.logout()
//                    return
//                }
            
            
            results.forEach {
                resultHandler($0)
            }
        }
    }
}
