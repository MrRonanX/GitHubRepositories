//
//  Notification + ext.swift
//  GitHubRepositories
//
//  Created by Roman Kavinskyi on 7/30/22.
//

import Foundation

extension Notification {
    var repositoryData: (id: Int, url: String)? {
        guard let userInfo = userInfo as? [String: Any],
              let url = userInfo["url"] as? String,
              let id = userInfo["id"] as? Int
        else { return nil }
        
        return (id, url)
    }
}

extension Notification.Name {
    
    static let searchRepositoryTapped = Notification.Name("searchRepositoryTapped")
    static let historyRepositoryTapped = Notification.Name("historyRepositoryTapped")
}
