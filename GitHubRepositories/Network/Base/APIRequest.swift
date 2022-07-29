//
//  APIRequest.swift
//  GitHubRepositories
//
//  Created by Roman Kavinskyi on 7/29/22.
//

import Foundation

protocol APIRequest {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var contentType: ContentType { get }
    var token: String? { get }
    var params: RequestParams { get }
}

extension APIRequest {
    var baseURL: String { APIEndpoint.Base.base.rawValue }
    var contentType: ContentType { .json }
    var token: String? { UserDefaults.standard.string(forKey: "authToken") }
    var params: RequestParams { .empty }
}

extension APIRequest {
    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: baseURL + path) else { throw APIError.invalidURL }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        let boundary = generateBoundaryString()
        
        switch contentType {
        case .formEncoded:
            urlRequest.setValue(ContentType.formEncoded.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        case .json:
            urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        case .multipart:
            let multipartContentType = ContentType.multipart.rawValue.appending("boundary=\(boundary)")
            urlRequest.setValue(multipartContentType, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        }
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        
        if let accessToken = token {
            urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
        }
        
        switch params {
        case let .body(params):
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        case let .form(params):
            var pairs = try params.reduce([]) { current, dictionary -> [String] in
                let value = dictionary.value
                let key = dictionary.key
                guard let encodedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                    throw APIError.invalidParams
                }
                return current + ["\(key)=\(String(describing: encodedValue))"]
            }
            pairs.sort()
            urlRequest.httpBody = pairs.joined(separator: "&").data(using: .utf8)
        case let .query(params):
            let queryParams = params.map { pair in
                return URLQueryItem(name: pair.key, value: "\(pair.value)")
            }
            var components = URLComponents(string: url.absoluteString)
            components?.queryItems = queryParams
            urlRequest.url = components?.url
        case let .path(params):
            var queryUrl = urlRequest.url
            params.forEach { pair in
                queryUrl?.appendPathComponent("\(pair.value)")
            }
            urlRequest.url = queryUrl
        case let .pathWithQuery(path, query):
            var queryUrl = urlRequest.url
            path.forEach { pair in
                queryUrl?.appendPathComponent("\(pair.value)")
            }
            let queryParams = query.map { pair in
                return URLQueryItem(name: pair.key, value: "\(pair.value)")
            }
            var components = URLComponents(string: queryUrl?.absoluteString ?? url.absoluteString)
            components?.queryItems = queryParams
            urlRequest.url = components?.url
       
        case .empty:
            break
        }
        return urlRequest
    }
    
    private func generateBoundaryString() -> String { "Boundary-\(UUID().uuidString)" }
    
    var debugDescription: String {
        var description = "-------------------------------------------------------------------------------------------"
        description.append("\n")
        description.append("PATH: ")
        description.append(baseURL + path)
        description.append("\n")
        description.append("METHOD: ")
        description.append(method.rawValue)
        description.append("\n")
        description.append("PARAMS: ")
        description.append(String(describing: params))
        return description
    }
   
}
