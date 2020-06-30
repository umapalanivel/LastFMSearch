//
//  URLConstructor.swift
//  LastFMSearch
//
//  Created by uma palanivel on 30/06/20.
//  Copyright © 2020 umapalanivel. All rights reserved.
//

import Foundation

struct URLManager {

static let baseURL = "http://ws.audioscrobbler.com"
static let apiVersion = "/2.0"

static func apiBaseURL() -> String {
    return "\(baseURL)\(apiVersion)"
}

}
