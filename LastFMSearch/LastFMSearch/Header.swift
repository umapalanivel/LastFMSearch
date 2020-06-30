//
//  Header.swift
//  LastFMSearch
//
//  Created by uma palanivel on 30/06/20.
//  Copyright © 2020 umapalanivel. All rights reserved.
//

import Foundation

struct Header {
    
    enum HeaderType {
        case unauthenticated
        case tokenJson
    }
    
    static let contentType = "Content-Type"
    static let applicationJson = "application/json"
    
    
    static func header (_ type: HeaderType) -> [String: String] {
        
        switch type {
        case .unauthenticated:
            return [:]
        case .tokenJson:
            return [self.contentType: self.applicationJson]
        }
    }
}
