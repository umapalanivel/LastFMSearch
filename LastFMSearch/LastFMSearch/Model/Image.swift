//
//  Image.swift
//  LastFMSearch
//
//  Created by uma palanivel on 30/06/20.
//  Copyright © 2020 umapalanivel. All rights reserved.
//

import Foundation

struct Image: Codable {
    var url: String
    var size: String
    
    enum CodingKeys: String, CodingKey {
        case url = "#text"
        case size = "size"
    }
}
