//
//  ResultTableViewModel.swift
//  LastFMSearch
//
//  Created by uma palanivel on 30/06/20.
//  Copyright © 2020 umapalanivel. All rights reserved.
//

import Foundation

class ResultTableViewModel {
    
    private var results: [SearchCriteria] = []
    private var searchState: SearchType = .artist
    private var selectedResult: SearchCriteria?
    
    func searchFor(_ keyword: String, completion: @escaping (Bool) -> ()) {
        Result.allResults(searchState, keyword: keyword) { (result) in
            guard let searchResults = result else { completion(false); return }
            self.results = searchResults
            completion(true)
        }
    }
    
    func resultForIndex(_ index: Int) -> SearchCriteria {
        return results[index]
    }
    
    func numberOfResults() -> Int {
        return results.count
    }
    
    func selectResult(_ index: Int) {
        selectedResult = results[index]
    }
    
    func getResult() -> SearchCriteria? {
        return selectedResult
    }
    
    func setSelectionState(_ index: Int) {
        switch index {
        case 0:
            searchState = .artist
        case 1:
            searchState = .album
        case 2:
            searchState = .track
        default:
            break
        }
    }
    
}
