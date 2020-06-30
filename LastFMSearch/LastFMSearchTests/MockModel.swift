//
//  MockModel.swift
//  LastFMSearchTests
//
//  Created by uma palanivel on 30/06/20.
//  Copyright © 2020 umapalanivel. All rights reserved.
//

import Foundation

struct MockModel: Codable, Equatable {
    let value: Int
    static var data = Data("{\"value\": 1}".utf8)
    static var model = MockModel(value: 1)
}
