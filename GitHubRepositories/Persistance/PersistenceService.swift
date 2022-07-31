//
//  PersistenceService.swift
//  GitHubRepositories
//
//  Created by Roman Kavinskyi on 7/31/22.
//

import Foundation

protocol PersistenceClient {
    func updateHistoryWith(repository: Repository, completed: @escaping (GRError?) -> Void)
    func retrieveRepositories(completed: @escaping (Result<[Repository], GRError>) -> Void)
    func saveWebData(_ data: Data, from url: URL)
    func loadWebData(with name: String) -> Data?
}

struct AppPersistenceClient: PersistenceClient {
    private let defaults = UserDefaults.standard
    
    private enum Keys {
        static let repositories = "repositories"
    }
    
    
    func updateHistoryWith(repository: Repository, completed: @escaping (GRError?) -> Void) {
        retrieveRepositories { result in
            switch result {
            case .success(var repositories):
                guard !repositories.contains(repository) else {
                    completed(nil)
                    return
                }
                
                if repositories.count > 19 {
                    let deletedRepo = repositories.removeLast()
                    deleteWebData(with: deletedRepo.url)
                }
                
                repositories.insert(repository, at: 0)
                completed(save(repositories: repositories))
                
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    
    func retrieveRepositories(completed: @escaping (Result<[Repository], GRError>) -> Void) {
        
        guard let repositoriesData = defaults.object(forKey: Keys.repositories) as? Data else {
            completed(.success([]))
            return
        }
        do {
            let decoder = JSONDecoder()
            let repositories = try decoder.decode([Repository].self, from: repositoriesData)
            completed(.success(repositories))
        } catch {
            completed(.failure(.unableToSave))
        }
    }
    
    
    private func save(repositories: [Repository]) -> GRError? {
        
        do {
            let encoder = JSONEncoder()
            let encodedRepositories = try encoder.encode(repositories)
            defaults.set(encodedRepositories, forKey: Keys.repositories)
            return nil
        } catch {
            return .unableToSave
        }
    }
    
    func saveWebData(_ data: Data, from url: URL) {
        guard let fileURL = FileManager.default.fileUrl(with: String(describing: url)) else { return }
        
        print(String(describing: url))
        do {
            try data.write(to: fileURL, options: .atomic)
        } catch {}
        
    }
    
    func loadWebData(with name: String) -> Data? {
        guard let fileURL = FileManager.default.fileUrl(with: name) else { return nil }
        
        do {
            let pageData = try Data(contentsOf: fileURL)
            return pageData
        } catch {
            return nil
        }
       
       
    }
    
    private func deleteWebData(with name: String) {
        guard let fileURL = FileManager.default.fileUrl(with: name) else { return }
        try? FileManager.default.removeItem(at: fileURL)
    }    
}
