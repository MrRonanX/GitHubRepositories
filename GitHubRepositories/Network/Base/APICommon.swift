//
//  APICommon.swift
//  GitHubRepositories
//
//  Created by Roman Kavinskyi on 7/29/22.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
}

enum ContentType: String {
    case formEncoded = "application/x-www-form-urlencoded; charset=utf-8"
    case json = "application/json"
    case multipart = "multipart/form-data; "
}

typealias HTTPCode = Int
typealias HTTPCodes = Range<HTTPCode>

extension HTTPCode {
    static let unauthorized = 401
}

extension HTTPCodes {
    static let success = 200..<300
}

typealias Parameters = [String: Any]
typealias PathParameters = KeyValuePairs<String, Any>

enum RequestParams {
    case body(_:Parameters)
    case form(_:Parameters)
    case query(_:Parameters)
    case path(_:PathParameters)
    case pathWithQuery(path: PathParameters, query: Parameters)
    case empty
}
