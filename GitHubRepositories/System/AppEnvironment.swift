//
//  AppEnvironment.swift
//  GitHubRepositories
//
//  Created by Roman Kavinskyi on 7/29/22.
//

import Foundation

struct AppEnvironment {
    let container: DIContainer
}

extension AppEnvironment {
    
    static func start() -> AppEnvironment {
        let appState = AppState()
        let session = configuredURLSession()
        let clients = configuredClients(session: session)
        let services = configuredServices(appState: appState, clients: clients)
        let container = DIContainer(appState: appState, services: services)
        return AppEnvironment(container: container)
    }
    
    private static func configuredURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        return URLSession(configuration: configuration)
    }
    
    private static func configuredClients(session: URLSession) -> DIContainer.Clients {
        let loginClient = RemoteLoginClient(session: session)
        let searchClient = RemoteSearchClient(session: session)
        return .init(loginClient: loginClient, searchClient: searchClient)
    }
    
    private static func configuredServices(appState: AppState,
                                           clients: DIContainer.Clients) -> DIContainer.Services {
        let authService = RemoteAuthService(appState: appState,
                                            loginClient: clients.loginClient)
        
        let searchService = RemoteSearchService(appState: appState, searchClient: clients.searchClient)
        
        
        return .init(authService: authService, searchService: searchService)
    }
}

struct DIContainer {
    let appState: AppState
    let services: Services
    
    init(appState: AppState, services: Services) {
        self.appState = appState
        self.services = services
    }
    
    static var preview: Self {
        .init(appState: AppState(), services: .stub)
    }
}

extension DIContainer {
    struct Clients {
        let loginClient: LoginClient
        let searchClient: SearchClient
    }
    
    struct Services {
        let authService: AuthService
        let searchService: SearchService
        
        
        static var stub: Self {
            .init(authService: StubAuthService(), searchService: StubSearchService())
        }
    }
}
