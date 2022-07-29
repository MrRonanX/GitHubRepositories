//
//  AuthResponse.swift
//  GitHubRepositories
//
//  Created by Roman Kavinskyi on 7/29/22.
//

import Foundation

struct AuthResponse: Codable {
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case token = "access_token"
    }
    
    init(from decoder: Decoder) throws {
        let decoder = try decoder.container(keyedBy: CodingKeys.self)
        token = try decoder.decodeIfPresent(String.self, forKey: .token) ?? ""
    }
}
