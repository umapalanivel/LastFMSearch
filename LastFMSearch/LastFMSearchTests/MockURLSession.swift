//
//  MockURLSession.swift
//  LastFMSearchTests
//
//  Created by uma palanivel on 30/06/20.
//  Copyright © 2020 umapalanivel. All rights reserved.
//

import Foundation

struct ResumableStub:Resumable{
    func resume() {}
}

class MockURLSession:URLSessionProtocol {
    
    private let urlSession = URLSession(configuration: .default)
    var lastRequest: URLRequest? = nil
    var lastCompletionHandler: ((Data?, URLResponse?, Error?) -> Void)? = nil
    
    func resumableDataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> Resumable {
        lastRequest = request
            lastCompletionHandler = completionHandler
            return ResumableStub()
        }
    }
    
   


