//
//  ItunesResponse.swift
//  iTunesTest
//
//  Created by Aurélien Haie on 10/04/2019.
//  Copyright © 2019 Aurélien Haie. All rights reserved.
//

import Foundation

struct ItunesResponse: Decodable {
    let resultCount: Int?
    let results: [App]?
}
