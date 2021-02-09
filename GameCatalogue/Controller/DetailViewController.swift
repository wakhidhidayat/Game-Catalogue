//
//  DetailViewController.swift
//  GameCatalogue
//
//  Created by Wahid Hidayat on 01/02/21.
//  Copyright © 2021 Wakhid Saiful Hidayat. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var released: UILabel!
    @IBOutlet weak var genres: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var id: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchGame()
    }
    
    func fetchGame() {
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
            
            var result: GameDetail?
            
            do {
                result = try JSONDecoder().decode(GameDetail.self, from: data)
            } catch {
                print("Error when decode json")
            }
            
            guard let finalResult = result else {
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
    
    func configure(
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
        self.overview.text = overview
        
        if let posterData =  try? Data(contentsOf: URL(string: poster)!) {
            self.poster.image = UIImage(data: posterData)
        }
        
        if let backgroundData =  try? Data(contentsOf: URL(string: background)!) {
            self.background.image = UIImage(data: backgroundData)
        }
        
        if let releasedData = released {
            self.released.text = releasedData
        } else {
            self.released.text = "-"
        }
    }
    
}
