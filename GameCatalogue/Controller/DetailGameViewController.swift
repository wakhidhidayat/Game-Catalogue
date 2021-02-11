//
//  DetailGameViewController.swift
//  GameCatalogue
//
//  Created by Wahid Hidayat on 01/02/21.
//  Copyright © 2021 Wakhid Saiful Hidayat. All rights reserved.
//

import UIKit

class DetailGameViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var released: UILabel!
    @IBOutlet weak var genres: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var id: Int?
    var result: GameDetail?
    var isInFavorites: Bool? = false
    
    private lazy var favoriteProvider: FavoriteProvider = { return FavoriteProvider() }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let isDataExist = isInFavorites else {
            return
        }
        if isDataExist {
            favoriteButton.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchGame()
    }
    
    private func fetchGame() {
        activityIndicator.startAnimating()
        guard let gameId = id else {
            return
        }
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.rawg.io"
        components.path = "/api/games/\(gameId)"
        
        let request = URLRequest(url: components.url!.absoluteURL)
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            guard let httpResponse =
                    response as? HTTPURLResponse,
                    httpResponse.statusCode >= 200 && httpResponse.statusCode < 300
            else {
                return
            }
            
            guard let data = data, error == nil else {
                return
            }
            
            do {
                self.result = try JSONDecoder().decode(GameDetail.self, from: data)
            } catch {
                print("Error when decode json")
            }
            
            guard let finalResult = self.result else {
                return
            }
            
            let posterUrl = finalResult.backgroundImage
            let backgroundUrl = finalResult.backgroundImageAdditional
            var genres = [String]()
            
            for genre in finalResult.genres {
                genres.append(genre.name)
            }
                        
            DispatchQueue.main.async {
                self.configure(
                    name: finalResult.name,
                    poster: posterUrl!,
                    background: backgroundUrl ?? "",
                    released: finalResult.released,
                    genres: genres.joined(separator: ", "),
                    rating: finalResult.rating,
                    overview: finalResult.description
                )
                self.activityIndicator.stopAnimating()
            }
        }).resume()
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
    
    private func createFavorite(_ sender: UIButton) {
        guard let finalResult = result else {
            return
        }
        
        var genres = [String]()
        
        for genre in finalResult.genres {
            genres.append(genre.name)
        }
        
        favoriteProvider.createFavorite(
            id!,
            finalResult.name,
            finalResult.released!,
            finalResult.backgroundImage!,
            finalResult.backgroundImageAdditional!,
            finalResult.rating,
            finalResult.description,
            genres.joined(separator: ", ")
        ) {
            DispatchQueue.main.async {
                self.isInFavorites?.toggle()
                self.setButtonBackGround(
                    view: sender,
                    on: UIImage(systemName: "suit.heart.fill")!,
                    off: UIImage(systemName: "suit.heart")!,
                    onOffStatus: self.isInFavorites!
                )
                let alert = UIAlertController(
                    title: "Succeeded",
                    message: "Game has been added to favorites.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func deleteFavorite(_ sender: UIButton) {
        guard let favoriteId = id else {
            return
        }
        favoriteProvider.deleteFavorite(favoriteId) {
            DispatchQueue.main.async {
                self.isInFavorites?.toggle()
                self.setButtonBackGround(
                    view: sender,
                    on: UIImage(systemName: "suit.heart.fill")!,
                    off: UIImage(systemName: "suit.heart")!,
                    onOffStatus: self.isInFavorites!
                )
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
    
    @IBAction func addToFavorite(_ sender: UIButton) {
        if isInFavorites! {
            deleteFavorite(sender)
        } else {
            createFavorite(sender)
        }
        print(String(isInFavorites!))
    }
    
    private func setButtonBackGround(view: UIButton, on: UIImage, off: UIImage, onOffStatus: Bool ) {
        switch onOffStatus {
        case true:
            view.setImage(on, for: .normal)
        default:
            view.setImage(off, for: .normal)
        }    }
}
