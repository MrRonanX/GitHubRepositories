//
//  LoginViewModel.swift
//  GitHubRepositories
//
//  Created by Roman Kavinskyi on 7/30/22.
//

import Foundation

extension LoginView {
    final class ViewModel: ObservableObject {
        
        @Published var showWebView = false
        
        let container: DIContainer
        
        var urlRequest: URLRequest {
            container.services.authService.authCodeRequest()
        }
        
        init(container: DIContainer) {
            self.container = container
        }
        
        func loginTapped() {
           showWebView = true
        }
    }
}
