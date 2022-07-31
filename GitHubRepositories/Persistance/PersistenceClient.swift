//
//  PersistenceClient.swift
//  GitHubRepositories
//
//  Created by Roman Kavinskyi on 7/31/22.
//

import Foundation

protocol PersistenceService {
    func updateHistoryWith(repository: Repository)
    func retrieveRepositories()
    func saveWebData(_ data: Data, from url: URL?)
    func loadWebData(with name: String?) -> Data?
}

struct AppPersistenceService: PersistenceService {

    let appState: AppState
    let persistenceClient: PersistenceClient
    
    func updateHistoryWith(repository: Repository) {
        persistenceClient.updateHistoryWith(repository: repository) { error in
            guard let error = error else { return }
            appState.alert(body: error.rawValue)
        }
    }
    
    func retrieveRepositories() {
        persistenceClient.retrieveRepositories { result in
            switch result {
            case .success(let repositories):
                appState.userData.historyItems = repositories
            case .failure(let error):
                appState.alert(body: error.rawValue)
            }
        }
    }
    
    func saveWebData(_ data: Data, from url: URL?) {
        guard let url = url else { return }
        persistenceClient.saveWebData(data, from: url)
    }
    
    func loadWebData(with name: String?) -> Data? {
        guard let name = name else { return nil }
        return persistenceClient.loadWebData(with: name)
    }
}

struct StudPersistenceService: PersistenceService {
    func updateHistoryWith(repository: Repository) {}
    func retrieveRepositories() {}
    func saveWebData(_ data: Data, from url: URL?) {}
    func loadWebData(with name: String?) -> Data? { nil }
}


