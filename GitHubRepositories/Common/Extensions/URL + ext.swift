//
//  URL + ext.swift
//  GitHubRepositories
//
//  Created by Roman Kavinskyi on 7/29/22.
//

import Foundation

extension URL {
    private var hasGitHubCode: Bool {
        absoluteString.hasPrefix(GitHubKeys.redirectUrl) && absoluteString.contains("code=")
    }
    
    /// Get the authorization code string after the '?code=' and before '&state='
    var authCode: String? {
        guard hasGitHubCode, let range = absoluteString.range(of: "=") else { return nil }
        
        let githubCode = absoluteString[range.upperBound...]
        
        guard let stateRange = githubCode.range(of: "&state=") else { return nil }
        
        return String(githubCode[..<stateRange.lowerBound])
    }
}

extension URL: Identifiable {
    
    public var id: String { absoluteString }
    
}
