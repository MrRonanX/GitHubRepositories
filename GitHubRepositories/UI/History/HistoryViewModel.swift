//
//  HistoryViewModel.swift
//  GitHubRepositories
//
//  Created by Roman Kavinskyi on 7/31/22.
//

import SwiftUI
import Combine

extension HistoryView {
    
    final class ViewModel: ObservableObject {
        @Published var repositories = [Repository]()
        @Published var selectedURL: URL?
        
        let container: DIContainer
        private var cancellables = Set<AnyCancellable>()
        
        init(_ container: DIContainer) {
            self.container = container
            
            container.appState.userData.$historyItems
                .dropFirst()
                .receive(on: RunLoop.main)
                .sink { [weak self] repositories in
                    self?.repositories = repositories
                }
                .store(in: &cancellables)
            
            NotificationCenter.default.publisher(for: .historyRepositoryTapped)
                .receive(on: RunLoop.main)
                .sink { [weak self] notification in
                    self?.handleOpenedRepository(notification)
                }
                .store(in: &cancellables)
        }
        
        func loadHistory() {
            container.services.persistenceClient.retrieveRepositories()
        }
        
        private func handleOpenedRepository(_ notification: NotificationCenter.Publisher.Output) {
            guard let userInfo = notification.repositoryData else { return }
            selectedURL = URL(string: userInfo.url)
        }
    }
}


