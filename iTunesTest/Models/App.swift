//
//  App.swift
//  iTunesTest
//
//  Created by Aurélien Haie on 09/04/2019.
//  Copyright © 2019 Aurélien Haie. All rights reserved.
//

import UIKit

struct App: Decodable {
    let screenshotUrls: [String]?
    let artworkUrl100: String?
    let averageUserRatingForCurrentVersion: Float?
    let trackCensoredName: String?
    let fileSizeBytes: String?
    let artistName: String?
    let price: Float?
    let contentAdvisoryRating: String?
    let description: String?
}
