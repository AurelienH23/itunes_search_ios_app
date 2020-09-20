//
//  AppCell.swift
//  iTunesTest
//
//  Created by Aurélien Haie on 09/04/2019.
//  Copyright © 2019 Aurélien Haie. All rights reserved.
//

import UIKit

class AppCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    /**
        The App object associated to the specific cell. Once the App object is passed to the collectionViewCell, the view is filled with the data from that object.
     */
    var app: App? {
        didSet {
            guard let app = app else { return }
            appTitleLabel.text = app.trackCensoredName
            if let imageUrl = app.artworkUrl100 {
                appImageView.loadImage(urlString: imageUrl)
            }
        }
    }
    
    // MARK: - View elements
    
    let appImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.layer.cornerRadius = 24
        iv.layer.borderWidth = 0.5
        iv.layer.borderColor = UIColor.lightGray.cgColor
        iv.clipsToBounds = true
        return iv
    }()
    
    let appTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom funcs
    
    /**
        Set the cell's view elements, the app icon on middle top and the app name juste below
     */
    fileprivate func setupCellViews() {
        addSubview(appImageView)
        addSubview(appTitleLabel)
        
        appImageView.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        appImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        appImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        appImageView.heightAnchor.constraint(equalTo: appImageView.widthAnchor).isActive = true
        
        appTitleLabel.anchor(top: appImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        appTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
}
