//
//  RepositoriesSearchResponse.swift
//  GitHubRepositories
//
//  Created by Roman Kavinskyi on 7/30/22.
//

import Foundation

struct RepositoriesSearchResponse: Codable {
    var incomplete_results: Bool
    var items: [Repository]
}

struct Repository: Codable, Identifiable, Equatable {
    let id: Int
    let fullName: String
    let description: String
    let url: String
    let language: String
    let stargazers: Int
    let license: License
    let updatedAt: String
    
    var licenseName: String {
        license.name
    }
    
    var stars: String {
        stargazers > 1000 ? String(stargazers / 1000) + "k" : String(stargazers)
    }
    
    var lastUpdate: String {
        DateTimeUtils.localDateFrom(string: updatedAt)
    }
    
    static func == (lhs: Repository, rhs: Repository) -> Bool {
        lhs.id == rhs.id
    }
    
    
}

extension Repository {
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case description
        case url = "html_url"
        case language
        case stargazers = "stargazers_count"
        case license
        case updatedAt = "updated_at"
    }
    
    init(from decoder: Decoder) throws {
        let decoder = try decoder.container(keyedBy: CodingKeys.self)
        id          = try decoder.decodeIfPresent(Int.self, forKey: .id) ?? 0
        fullName    = try decoder.decodeIfPresent(String.self, forKey: .fullName) ?? ""
        description = try decoder.decodeIfPresent(String.self, forKey: .description) ?? ""
        url         = try decoder.decodeIfPresent(String.self, forKey: .url) ?? ""
        language    = try decoder.decodeIfPresent(String.self, forKey: .language) ?? ""
        stargazers  = try decoder.decodeIfPresent(Int.self, forKey: .stargazers) ?? 0
        license     = try decoder.decodeIfPresent(License.self, forKey: .license) ?? License(name: "")
        updatedAt   = try decoder.decodeIfPresent(String.self, forKey: .updatedAt) ?? ""
    }
    
    static let empty = Self(id: 0,
                            fullName: "mrronanx/GitHubRepositories",
                            description: "A test task implementation for Headway",
                            url: "https://github.com/MrRonanX/GitHubRepositories",
                            language: "Swift",
                            stargazers: 42,
                            license: License(name: "MIT"),
                            updatedAt: "2020-07-30T17:58:47Z")
}

struct License: Codable {
    let name: String
}
