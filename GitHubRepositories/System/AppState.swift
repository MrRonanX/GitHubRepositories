//
//  AppState.swift
//  GitHubRepositories
//
//  Created by Roman Kavinskyi on 7/29/22.
//

import SwiftUI

final class AppState: ObservableObject {
    
    @Published var isLoading = false
    @Published var loggedInStatus = false
    
    @Published var alert: AppAlert = .empty
    @Published var userData = UserData()
    
    @Published var token: String? {
        didSet {
            UserDefaults.standard.set(token, forKey: "authToken")
        }
    }
    
    init() {
        token = UserDefaults.standard.string(forKey: "authToken")
    }
    
    func logout() {
        
    }
    
    func alert(title: String = "", body: String) {
        alert = AppAlert(title: title, body: body)
    }
}

extension AppState {
    class UserData {
        @Published var repositorySearchResults = RepositoriesSearchResponse(incomplete_results: false, items: [])
    }
}

struct AppAlert {
    let title: String
    let body: String

    internal init(title: String = "", body: String = "") {
        self.title = title
        self.body = body
    }
    
    static var empty = Self()
}
