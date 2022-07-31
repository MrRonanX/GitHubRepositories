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
            
            results.forEach {
                resultHandler($0)
            }
        }
    }
}
