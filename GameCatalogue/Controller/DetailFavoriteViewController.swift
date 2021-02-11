//
//  DetailFavoriteViewController.swift
//  GameCatalogue
//
//  Created by Wahid Hidayat on 10/02/21.
//  Copyright © 2021 Wakhid Saiful Hidayat. All rights reserved.
//

import UIKit

class DetailFavoriteViewController: UIViewController {

    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var released: UILabel!
    @IBOutlet weak var genres: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var game: FavoriteModel?
    private lazy var favoriteProvider: FavoriteProvider = { return FavoriteProvider() }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorite()
    }
    
    private func loadFavorite() {
        activityIndicator.startAnimating()
        guard let gameData = game else {
            return
        }
        
        DispatchQueue.main.async {
            self.configure(
                name: gameData.name!,
                poster: gameData.backgroundImage!,
                background: gameData.backgroundImageAdditional!,
                released: gameData.released,
                genres: gameData.genres!,
                rating: gameData.rating!,
                overview: gameData.overview!
            )
            self.activityIndicator.stopAnimating()
        }
    }
    
    private func configure(
        name: String,
        poster: String,
        background: String,
        released: String?,
        genres: String,
        rating: Double,
        overview: String
    ) {
        self.genres.text = genres
        self.name.text = name
        self.rating.text = "\(rating) / 5"
        self.overview.text = Util.removeHTMLTags(in: overview)
        
        if let posterData =  try? Data(contentsOf: URL(string: poster)!) {
            self.poster.image = UIImage(data: posterData)
        }
        
        if let backgroundData =  try? Data(contentsOf: URL(string: background)!) {
            self.background.image = UIImage(data: backgroundData)
        }
        
        if let releasedData = released {
            self.released.text = Util.formatDate(from: releasedData)
        } else {
            self.released.text = "-"
        }
    }
    
    @IBAction func removeFromFavorites(_ sender: UIButton) {
        guard let id = game?.id else {
            return
        }
        let favoriteId = Int(id)
        
        favoriteProvider.deleteFavorite(favoriteId) {
            DispatchQueue.main.async {
                self.favoriteButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
                let alert = UIAlertController(
                    title: "Removed Succeeded",
                    message: "Game has been removed from favorites.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
