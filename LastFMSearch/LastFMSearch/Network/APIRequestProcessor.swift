//
//  APIRequestProcessor.swift
//  LastFMSearch
//
//  Created by uma palanivel on 30/06/20.
//  Copyright © 2020 umapalanivel. All rights reserved.
//

import Foundation

import Foundation

enum SearchType: String {
    case album
    case track
    case artist
}

enum APIEndpoint: String {
    case search
    case getInfo
}

class APIClient {
    
    private let apiKey = "66275d7c0df9344f23cbbdecdc6ba3bf"
    private let rateLimit = 10
    
    var session = URLSession.shared
    
    enum HTTPMethod: String {
        case GET
        case PUT
        case POST
        case DEL
    }
    
    
    func searchForKeywordWithType(_ type: SearchType, keyword: String, completion: @escaping (Data?, Error?) -> Void) {
        makeRequest(.GET,
                    url: URLManager.apiBaseURL(),
                    params: ["method": "\(type.rawValue).\(APIEndpoint.search.rawValue)" as AnyObject,
                             type.rawValue : keyword as AnyObject,
                             "api_key": apiKey as AnyObject,
                             "format": "json" as AnyObject],
                    headers: Header.header(.tokenJson),
                    onSuccess: { (jsonData) in
                        completion(jsonData, nil)
        }) { (error) in
            completion(nil, error)
        }
    }
    
    func getInfoForKeywordWithType(_ type: SearchType, keyword: String, completion: @escaping (Data?, Error?) -> Void) {
        makeRequest(.GET,
                    url: URLManager.apiBaseURL(),
                    params: ["method": "\(type.rawValue).\(APIEndpoint.getInfo.rawValue)" as AnyObject,
                             type.rawValue : keyword as AnyObject,
                             "api_key": apiKey as AnyObject,
                             "format": "json" as AnyObject,
                             "limit": rateLimit as AnyObject],
                    headers: nil,
                    onSuccess: { (jsonData) in
                        completion(jsonData, nil)
        }) { (error) in
            completion(nil, error)
        }
    }
    
    fileprivate func makeRequest(_ method: HTTPMethod,
                                 url: String,
                                 params: [String: AnyObject]?,
                                 headers: [String: String]?,
                                 onSuccess: @escaping(_ jsonData: Data) -> Void,
                                 onError: @escaping(_ error: Error?) -> Void) {
        
        
        //        guard let url = URL(string: url) else { return }
        
        var components = URLComponents(string: url)!
        components.queryItems = params!.map { (arg) -> URLQueryItem in
            
            let (key, value) = arg
            return URLQueryItem(name: key, value: value as? String)
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        let request = constructRequest(components.url!, method: method, params: params, headers: headers)
        
        session.dataTask(with: request) { (data, response, err) in
            if err == nil {
                if let data = data, let response = response as? HTTPURLResponse {
                    if 200...299 ~= response.statusCode {
                        onSuccess(data)
                    } else {
                        let errorTemp = NSError(domain:"", code:response.statusCode, userInfo:nil)
                        onError(errorTemp)
                    }
                }
            } else {
                onError(err)
            }
            
            }.resume()
        
    }
    
    fileprivate func constructRequest(_ url: URL, method: HTTPMethod, params: [String: AnyObject]?, headers: [String: String]?) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        return request
    }
    
}
