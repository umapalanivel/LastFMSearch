//
//  SearchResultViewController.swift
//  LastFMSearch
//
//  Created by uma palanivel on 30/06/20.
//  Copyright © 2020 umapalanivel. All rights reserved.
//

import UIKit
import SafariServices

class SearchResultViewController: UIViewController {

    @IBOutlet weak var resultImageView: UIImageView!
        @IBOutlet weak var resultTitleLabel: UILabel!
        @IBOutlet weak var numberOfListenersLabel: UILabel!
        @IBOutlet weak var listenerView: UIView!
        @IBOutlet weak var listenHereButton: UIButton! {
            didSet {
                listenHereButton.layer.cornerRadius = 8
                listenHereButton.backgroundColor = UIColor(red: 9.0 / 255.0, green: 132.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0)
            }
        }
        
        var result: SearchCriteria?
        
        private let animationStartDate = Date()
        private let animationDuration = 2.0
        private var numberOfListeners: Double = 0.0
        
        override func viewDidLoad() {
            super.viewDidLoad()

            setupViews()
        }

        
        
        private func setupViews() {
            guard let result = result else { return }
            resultTitleLabel.text = result.name
            resultImageView.imageFromServerURL(result.image[2].url, placeHolder: nil)
            
            switch result {
            case is Artist:
                let artist = result as! Artist
                numberOfListeners = Double(artist.listeners) ?? 0.0
            case is Track:
                let track = result as! Track
                numberOfListeners = Double(track.listeners) ?? 0.0
            case is Album:
                listenerView.isHidden = true
            default:
                break
            }
            
            let displayLink = CADisplayLink(target: self, selector: #selector(handleUpdate))
            displayLink.add(to: .main, forMode: RunLoop.Mode.default)
          
        }
        
        @objc func handleUpdate() {
            let now = Date()
            let elapsedTime = now.timeIntervalSince(animationStartDate)
            if elapsedTime > animationDuration {
                numberOfListenersLabel.text = "\(Int(numberOfListeners))"
            } else {
                let percentage = elapsedTime / animationDuration
                let value = percentage * numberOfListeners
                numberOfListenersLabel.text = "\(Int(value))"
            }
        }
    
       @IBAction func openLink(_ sender: UIButton) {
           guard let urlString = result?.url else { return }
           guard let url = URL(string: urlString) else { return }
           if #available(iOS 11.0, *) {
               let config = SFSafariViewController.Configuration()
               config.entersReaderIfAvailable = true
               
               let vc = SFSafariViewController(url: url, configuration: config)
               present(vc, animated: true)
           } else {
               UIApplication.shared.open(url)
           }
       }
       

    }
