//
//  ContentViewModel.swift
//  GitHubRepositories
//
//  Created by Roman Kavinskyi on 7/31/22.
//

import Foundation
import Combine
import Network

extension ContentView {
   
    final class ViewModel: ObservableObject {
        
        @Published var isLoggedIn = false
        @Published var hasAlert = false
        @Published var isLoading = false
        
        @Published private var isConnected = false
        private let monitor = NWPathMonitor()
        private let queue = DispatchQueue.global(qos: .utility)
        
        
        private(set) var alert: AppAlert = .empty
        
        private var cancellables = Set<AnyCancellable>()
        
        let container: DIContainer
        
        init(container: DIContainer) {
            self.container = container
            
            if let token = container.appState.token, !token.isEmpty {
                isLoggedIn = true
            }
            
            container.appState.$token
                .receive(on: RunLoop.main)
                .map { !($0?.isEmpty ?? true) }
                .assign(to: \.isLoggedIn, on: self)
                .store(in: &cancellables)
            
            container.appState.$alert
                .dropFirst()
                .receive(on: RunLoop.main)
                .sink { [weak self] alert in
                    self?.alert = alert
                    self?.hasAlert = true
                }
                .store(in: &cancellables)
            
            container.appState.$isLoading
                .dropFirst()
                .receive(on: RunLoop.main)
                .assign(to: \.isLoading, on: self)
                .store(in: &cancellables)
            
            $isConnected
                .dropFirst()
                .receive(on: RunLoop.main)
                .sink { [weak self] value in
                    self?.container.appState.hasNetwork = value
                }
                .store(in: &cancellables)
            
            activateMonitor()
                
        }
        
        private func activateMonitor() {
            monitor.pathUpdateHandler = pathHandler
            monitor.start(queue: queue)
        }
        
        private func pathHandler(_ path: NWPath) {
            DispatchQueue.main.async {
                print(path.status == .satisfied)
                self.isConnected = path.status == .satisfied
            }
        }
    }
}
