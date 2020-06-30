//
//  LastFMSearchTests.swift
//  LastFMSearchTests
//
//  Created by uma palanivel on 29/06/20.
//  Copyright © 2020 umapalanivel. All rights reserved.
//

import XCTest
@testable import LastFMSearch
let url = URL(string: "http://ws.audioscrobbler.com/2.0/")!
class LastFMSearchTests: XCTestCase,Decodable {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func test_load_whenSuccessfulRequest() {
            let mockURLSession = MockURLSession()
            let api = API(urlSession: mockURLSession, baseURL: url)
            
            
            let callbackExpectation = expectation(description: "updated")
            api.load(Endpoint<MockModel>(path: "")) { result in
                callbackExpectation.fulfill()
                guard let model = try? result.get() else {
                    XCTFail("Expected success got error")
                    return
                }
                XCTAssertEqual(MockModel.model, model)
            }
            mockURLSession.lastCompletionHandler?(MockModel.data, HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: [:]), nil)
            wait(for: [callbackExpectation], timeout: 0.1)
        }
    }


