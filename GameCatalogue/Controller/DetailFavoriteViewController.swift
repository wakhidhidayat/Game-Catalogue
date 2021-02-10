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
    
    var game: FavoriteModel?
    private lazy var favoriteProvider: FavoriteProvider = { return FavoriteProvider() }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorite()
    }
    private func loadFavorite() {
        guard let gameData = game else {
            return
        }
        DispatchQueue.main.async {
            self.configure(
                name: gameData.name!,
                poster: gameData.backgroundImage!,
                background: gameData.backgroundImageAdditional!,
                released: gameData.released,
                genres: "-",
                rating: gameData.rating!,
                overview: gameData.overview!
            )
        }
    }
    
    func configure(
        name: String,
        poster: String,
        background: String,
        released: String?,
        genres: String,
        rating: Double,
        overview: String
    ) {
        self.genres.text = "-"
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

}
