//
//  APIClient.swift
//  GitHubRepositories
//
//  Created by Roman Kavinskyi on 7/29/22.
//

import Foundation

protocol APIClient {
    var session: URLSession { get }
}

extension APIClient {
    func request<T: Decodable>(_ request: APIRequest) async -> Result<T, APIError> {
        //print(request.debugDescription)
        do {
            let request = try request.asURLRequest()
            let (data, response) = try await session.data(for: request, delegate: nil)
            assert(!Thread.isMainThread)
            guard let code = (response as? HTTPURLResponse)?.statusCode else { throw APIError.invalidHTTPResponse }
            //print(String(data: data, encoding: .utf8))
            if HTTPCodes.success.contains(code) {
                let json = try JSONDecoder().decode(T.self, from: data)
                return .success(json)
            } else {
                return .failure(.unexpected)
            }
        } catch let error {
            print(error)
            if let error = error as? APIError { return .failure(error) }
            return .failure(.unexpected)
        }
    }
}
