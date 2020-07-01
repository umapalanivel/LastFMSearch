//
//  ResultsTableViewCell.swift
//  LastFMSearch
//
//  Created by uma palanivel on 30/06/20.
//  Copyright © 2020 umapalanivel. All rights reserved.
//

import UIKit

class ResultsTableViewCell: UITableViewCell {

    @IBOutlet weak var resultTitleLabel: UILabel!
    @IBOutlet weak var resultImageView: UIImageView!
        
    func configure(_ result: SearchCriteria) {
        resultTitleLabel.text = result.name
        resultImageView.imageFromServerURL(result.image[2].url, placeHolder: nil)
    }

    


}
