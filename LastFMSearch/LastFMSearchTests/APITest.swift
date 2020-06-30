//
//  APITest.swift
//  LastFMSearchTests
//
//  Created by uma palanivel on 30/06/20.
//  Copyright © 2020 umapalanivel. All rights reserved.
//

import Foundation


enum HTTPError: Error {
    case noResponse
    case requestError(Error)
    case invalidResponse(URLResponse)
    case errorResponse(LastFmError)
    case unsuccessful(statusCode: Int, urlResponse: HTTPURLResponse, error: Error?)
}

extension HTTPError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noResponse:
            return "No Response"
        case .requestError(let error):
            return "Request Error: \(error)"
        case .invalidResponse(let response):
            return "Invalid response. Expected HTTPURLResponse got \(type(of: response))"
        case .errorResponse(let lastFmError):
            return lastFmError.message
        case .unsuccessful(let statusCode, _, _):
            return "Unsuccessful. Status code: \(statusCode)"
        }
    }
}

struct LastFmError: Decodable {
    let error: Int
    let message: String
    
    struct Codes {
        static let invalidApiKey = 10
    }
}


struct API {
    private let urlSession: URLSessionProtocol
    private let baseURL: URL
    
    init(urlSession: URLSessionProtocol, baseURL: URL) {
        self.urlSession = urlSession
        self.baseURL = baseURL
    }
    
    func load<Entity>(_ endpoint: Endpoint<Entity>, completion: @escaping (Result<Entity, Error>) -> Void) {
        var urlComponents = URLComponents(url: baseURL.appendingPathComponent(endpoint.path), resolvingAgainstBaseURL: false)
        urlComponents?.query = endpoint.query
        guard let url = urlComponents?.url else {
            assertionFailure("Invalid endpoint: \(endpoint)")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method
        
        print("Sending request: \(endpoint)")
        let task = urlSession.resumableDataTask(with: urlRequest, completionHandler: { data, urlResponse, error in
            guard let urlResponse = urlResponse else {
                completion(.failure(HTTPError.noResponse))
                return
            }
            if let error = error {
                completion(.failure(HTTPError.requestError(error)))
                return
            }
            guard let httpURLResponse = urlResponse as? HTTPURLResponse else {
                completion(.failure(HTTPError.invalidResponse(urlResponse)))
                return
            }
            guard (200..<300).contains(httpURLResponse.statusCode) else {
                guard let data = data,
                    case let .success(lastFmError) = Endpoint<LastFMSearchTests>(path: "").parse(data) else {
                        completion(.failure(HTTPError.unsuccessful(statusCode: httpURLResponse.statusCode, urlResponse: httpURLResponse, error: error)))
                        return
                }

                //completion(.failure(HTTPError.errorResponse(lastFmError)))
                return
            }
            guard let data = data else {
                assertionFailure("Data is missing in the response")
                return
            }
            
            completion(endpoint.parse(data))
        })
        
        task.resume()
    }
    
    func load(from urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            assertionFailure("Invalid url: \(urlString)")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        print("Sending request: \(url)")
        let task = urlSession.resumableDataTask(with: urlRequest, completionHandler: { data, _, error in
            if let error = error {
                completion(.failure(HTTPError.requestError(error)))
                return
            }
            guard let data = data else {
                assertionFailure("Data is missing in the response")
                return
            }
            
            completion(.success(data))
        })
        
        task.resume()
    }
}

// MARK: - Resumable

protocol Resumable {
    func resume()
}

extension URLSessionDataTask: Resumable {}

// MARK: - URLSessionProtocol

protocol URLSessionProtocol {
    func resumableDataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> Resumable
}

extension URLSession: URLSessionProtocol {
    func resumableDataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> Resumable {
        return dataTask(with: request, completionHandler: completionHandler)
    }
}
