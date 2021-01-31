//
//  GameViewController.swift
//  GameCatalogue
//
//  Created by Wahid Hidayat on 31/01/21.
//  Copyright © 2021 Wakhid Saiful Hidayat. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    
    var games = [Game]()
    var activityIndicator: UIActivityIndicatorView!
    
    override func loadView() {
        super.loadView()
        
        activityIndicator = UIActivityIndicatorView(style: .large)
        table.backgroundView = activityIndicator
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Popular Games"
        fetchGames()
        
        table.register(GameTableViewCell.nib(), forCellReuseIdentifier: GameTableViewCell.identifier)
        table.dataSource = self
    }
    
    func fetchGames() {
        activityIndicator.startAnimating()
        table.separatorStyle = .none
        
        let components = URLComponents(string: "https://api.rawg.io/api/games")!
        
        let request = URLRequest(url: components.url!)
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
                return
            }
            
            guard let data = data, error == nil else {
                return
            }
            
            var result: GameResult?
            
            do {
                result = try JSONDecoder().decode(GameResult.self, from: data)
            } catch {
                print("Error when decode json")
            }
            
            guard let finalResult = result else {
                return
            }
            
            let gameResult = finalResult.games
            self.games.append(contentsOf: gameResult)
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.table.separatorStyle = .singleLine
                self.table.reloadData()
            }
        }).resume()
    }
}

extension GameViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GameTableViewCell.identifier, for: indexPath) as! GameTableViewCell
        cell.configure(with: games[indexPath.row])
        return cell
    }
}
