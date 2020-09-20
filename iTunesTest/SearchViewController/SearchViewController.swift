//
//  SearchViewController.swift
//  iTunesTest
//
//  Created by Aurélien Haie on 08/04/2019.
//  Copyright © 2019 Aurélien Haie. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    var searchedApps = [App]() {
        didSet {
            DispatchQueue.main.async {
                if self.searchedApps.count == 0 {
                    self.explanationLabel.alpha = 1
                } else {
                    self.explanationLabel.alpha = 0
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    let cellId = "cellId"
    var timer: Timer?
    
    // MARK: - View elements
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.searchBarStyle = .minimal
        sb.placeholder = "Rechercher"
        sb.delegate = self
        return sb
    }()
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.backgroundColor = .white
        cv.keyboardDismissMode = .interactive
        cv.alwaysBounceVertical = true
        cv.register(AppCell.self, forCellWithReuseIdentifier: cellId)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    let explanationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        let attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: "0 résultat pour cette recherche", attributes: [.font: UIFont.boldSystemFont(ofSize: 24)]))
        attributedText.append(NSAttributedString(string: "\n\nTapez le nom de l'application que vous souhaitez dans la barre de recherche", attributes: [.font: UIFont.systemFont(ofSize: 24)]))
        label.attributedText = attributedText
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupViews()
    }

    // MARK: - Custom func
    
    fileprivate func setupNavBar() {
        navigationItem.title = "iTunes"
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .white
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = .white
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(explanationLabel)
        
        searchBar.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        collectionView.anchor(top: searchBar.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        explanationLabel.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        explanationLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    /**
     Get the JSON returned by the iTunes API for the typed text and transform it into an array of Apps object usable for the collection view.
     */
    fileprivate func getApps(for searchText: String) {
        // transform the special characters into allowed characters for an URL
        guard let encodedTerm = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        guard let url = URL(string: "https://itunes.apple.com/search?entity=software&country=fr&limit=10&term=\(encodedTerm)") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let decodedResponse = try JSONDecoder().decode(ItunesResponse.self, from: data)
                self.searchedApps = decodedResponse.results ?? []
            } catch let error {
                print("Failed to load: \(error)")
            }
        }.resume()
    }
    
    // MARK: SearchBar delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // start searching the matching apps 0.5s after the user finished typing
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            if !searchText.isEmpty {
                self.getApps(for: searchText)
            }
        })
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - CollectionView delegate & datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchedApps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppCell
        cell.app = searchedApps[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width*0.5, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsViewController = DetailsViewController()
        detailsViewController.app = searchedApps[indexPath.row]
        navigationController?.pushViewController(detailsViewController, animated: true)
    }

}
