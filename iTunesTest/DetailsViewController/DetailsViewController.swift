//
//  DetailsViewController.swift
//  iTunesTest
//
//  Created by Aurélien Haie on 09/04/2019.
//  Copyright © 2019 Aurélien Haie. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    var app: App? {
        didSet {
            guard let app = app else { return }
            
            // header
            if let imageUrl = app.artworkUrl100 {
                appImageView.loadImage(urlString: imageUrl)
            }
            
            appTitleLabel.text = app.trackCensoredName
            title = app.trackCensoredName
            authorNameLabel.text = app.artistName
            
            // price
            if let price = app.price {
                if price == 0 {
                    priceLabel.text = "GRATUIT"
                } else {
                    priceLabel.text = "\(price)€"
                }
            }
            
            // mark
            if let mark = app.averageUserRatingForCurrentVersion {
                let attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: "\(mark)", attributes: [.font: UIFont.boldSystemFont(ofSize: 24), .foregroundColor: UIColor.black]))
                attributedText.append(NSAttributedString(string: " / 5", attributes: [.font: UIFont.systemFont(ofSize: 20), .foregroundColor: UIColor.lightGray]))
                markLabel.attributedText = attributedText
            }
            
            // size
            if let bytes = app.fileSizeBytes, let count = Int64(bytes) {
                fileSizeLabel.text = ByteCountFormatter.string(fromByteCount: count, countStyle: .file)
            }
            
            // age
            if let age = app.contentAdvisoryRating {
                let attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: "\(age)", attributes: [.font: UIFont.boldSystemFont(ofSize: 24)]))
                attributedText.append(NSAttributedString(string: "\nAge", attributes: [.font: UIFont.systemFont(ofSize: 16)]))
                ageLabel.attributedText = attributedText
            }
            
            // description
            if let descriptionText = app.description {
                descriptionTextView.text = descriptionText
                let descriptionHeight = app.description?.height(withConstrainedWidth: view.frame.width - 32, font: .systemFont(ofSize: 18))
                descriptionTextView.heightAnchor.constraint(equalToConstant: descriptionHeight! > 200 ? 200 : descriptionHeight!).isActive = true
            }
            
            // screenshots
            if let screenshotUrl = app.screenshotUrls?.first {
                screenshotImageView.loadImage(urlString: screenshotUrl)
            }
            
            updateScrollViewContentSize()
        }
    }
    
    // MARK: - View elements
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView(frame: .zero)
        return sv
    }()
    
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
        label.font = .boldSystemFont(ofSize: 28)
        return label
    }()
    
    let authorNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .lightGray
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .heavy)
        label.backgroundColor = .blue
        label.layer.cornerRadius = 18
        label.clipsToBounds = true
        return label
    }()
    
    let markLabel: UILabel = {
        let label = UILabel()
        label.text = "- / 5"
        label.textAlignment = .left
        return label
    }()
    
    let fileSizeLabel: UILabel = {
        let label = UILabel()
        label.text = "- Mo"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24)
        label.textColor = .lightGray
        return label
    }()
    
    let ageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "-"
        label.textAlignment = .right
        label.textColor = .lightGray
        return label
    }()
    
    let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        return label
    }()
    
    let descriptionTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 18)
        return tv
    }()
    
    let screenshotImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.layer.borderWidth = 0.5
        iv.layer.borderColor = UIColor.lightGray.cgColor
        iv.layer.cornerRadius = 24
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Custom funcs
    
    fileprivate func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.anchor(to: view)
        
        scrollView.addSubview(appImageView)
        scrollView.addSubview(appTitleLabel)
        scrollView.addSubview(authorNameLabel)
        scrollView.addSubview(priceLabel)

        appImageView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 125, height: 125)
        appTitleLabel.anchor(top: appImageView.topAnchor, left: appImageView.rightAnchor, bottom: nil, right: scrollView.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: view.frame.width - 173, height: 0)
        authorNameLabel.anchor(top: appTitleLabel.bottomAnchor, left: appImageView.rightAnchor, bottom: nil, right: scrollView.rightAnchor, paddingTop: 4, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        priceLabel.anchor(top: nil, left: nil, bottom: appImageView.bottomAnchor, right: scrollView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 84, height: 36)

        let stackView = UIStackView(arrangedSubviews: [markLabel, fileSizeLabel, ageLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        scrollView.addSubview(stackView)

        stackView.anchor(top: appImageView.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 60)

        scrollView.addSubview(divider)
        scrollView.addSubview(descriptionTitleLabel)
        scrollView.addSubview(descriptionTextView)
        scrollView.addSubview(screenshotImageView)

        divider.anchor(top: stackView.bottomAnchor, left: stackView.leftAnchor, bottom: nil, right: stackView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        descriptionTitleLabel.anchor(top: divider.bottomAnchor, left: divider.leftAnchor, bottom: nil, right: divider.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        descriptionTextView.anchor(top: descriptionTitleLabel.bottomAnchor, left: descriptionTitleLabel.leftAnchor, bottom: nil, right: descriptionTitleLabel.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        screenshotImageView.anchor(top: descriptionTextView.bottomAnchor, left: descriptionTextView.leftAnchor, bottom: nil, right: descriptionTextView.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        screenshotImageView.heightAnchor.constraint(equalTo: screenshotImageView.widthAnchor, multiplier: 2.03).isActive = true
        
        updateScrollViewContentSize()
    }
    
    /**
     Set the scrollView's content size as big as its content.
     */
    fileprivate func updateScrollViewContentSize() {
        scrollView.layoutIfNeeded()
        var contentRect = CGRect.zero
        for subview in scrollView.subviews {
            contentRect = contentRect.union(subview.frame)
        }
        scrollView.contentSize = CGSize(width: view.frame.width, height: contentRect.height + 16)
    }
    
}
