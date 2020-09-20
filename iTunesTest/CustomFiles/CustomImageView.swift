//
//  CustomImageView.swift
//  iTunesTest
//
//  Created by Aurélien Haie on 10/04/2019.
//  Copyright © 2019 Aurélien Haie. All rights reserved.
//

import UIKit

/**
 Contains the downloaded images so the device doesn't need to download them again if needed.
 */
var imageCache = [String: UIImage]()

/**
 An UIImageView with a method that easily load an images from an URL string.
 */
class CustomImageView: UIImageView {
    
    var lastURLUsedToLoadImage: String?
    
    /**
     Loads an image from a URL string and save it in the cache
     */
    func loadImage(urlString: String) {
        image = nil
        
        lastURLUsedToLoadImage = urlString
        
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Failed to fetch image: \(err)")
                return
            }
            
            if url.absoluteString != self.lastURLUsedToLoadImage {
                return
            }
            
            guard let imageData = data else { return }
            let photoImage = UIImage(data: imageData)
            imageCache[url.absoluteString] = photoImage
            
            DispatchQueue.main.async {
                self.image = photoImage
            }
        }.resume()
    }
}
