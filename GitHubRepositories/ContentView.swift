//
//  ContentView.swift
//  GitHubRepositories
//
//  Created by Roman Kavinskyi on 7/28/22.
//

import SwiftUI
import Combine

final class ViewModel: ObservableObject {
    
    @Published var isLoggedIn = false
    @Published var hasAlert = false
    @Published var isLoading = false
    
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
    }
}

struct ContentView: View {
    
    @StateObject var viewModel: ViewModel
    
    let environment: AppEnvironment
    
    init() {
        environment = AppEnvironment.start()
        
        let viewModel = ViewModel(container: environment.container)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            VStack {
                if viewModel.isLoggedIn {
                    TabBarView(viewModel: .init(container: viewModel.container))
                } else {
                    LoginView(viewModel: .init(container: viewModel.container))
                }
            }
            
            if viewModel.isLoading {
                
            }
            
        }
        .animation(.default, value: viewModel.isLoggedIn)
        .alert(isPresented: $viewModel.hasAlert) {
            Alert(with: viewModel.alert)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
            .previewInterfaceOrientation(.portrait)
    }
}



