//
//  APIError.swift
//  GitHubRepositories
//
//  Created by Roman Kavinskyi on 7/29/22.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidHTTPResponse
    case invalidParams
    case message(String?)
    case unauthorized(String?)
    case unexpected
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .invalidHTTPResponse: return "Unexpected response from server"
        case .invalidParams: return "Invalid parameters in request"
        case let .message(error): return error ?? ""
        case let .unauthorized(message): return message ?? ""
        case .unexpected: return "Unexpected error"
        }
    }
}
