//
//  TabBarViewModel.swift
//  GitHubRepositories
//
//  Created by Roman Kavinskyi on 7/30/22.
//

import Foundation

extension TabBarView {
    final class ViewModel: ObservableObject {
        let container: DIContainer
        
        init(container: DIContainer) {
            self.container = container
        }
    }
}
