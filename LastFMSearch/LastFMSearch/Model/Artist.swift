//
//  Artist.swift
//  LastFMSearch
//
//  Created by uma palanivel on 30/06/20.
//  Copyright © 2020 umapalanivel. All rights reserved.
//

import Foundation

struct Artistmatches: Codable, Match {
    let artist: [Artist]
}

struct Artist: Codable, SearchCriteria {
    var id: String
    var name: String
    var listeners: String
    var url: String
    var streamable: String
    var image: [Image]
    
    enum CodingKeys: String, CodingKey {
        case id = "mbid"
        case name
        case listeners
        case url
        case streamable
        case image
    }
}
