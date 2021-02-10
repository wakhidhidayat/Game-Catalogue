//
//  FavoriteViewController.swift
//  GameCatalogue
//
//  Created by Wahid Hidayat on 09/02/21.
//  Copyright © 2021 Wakhid Saiful Hidayat. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {

    @IBOutlet var table: UITableView!
    
    var favorites = [FavoriteModel]()
    private lazy var favoriteProvider: FavoriteProvider = { return FavoriteProvider() }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites()
    }
    
    private func loadFavorites() {
        self.favoriteProvider.getFavorites { (result) in
            DispatchQueue.main.async {
                self.favorites = result
                self.table.reloadData()
            }
        }
    }

    private func setupView() {
        self.navigationItem.title = "Favorites"
        table.register(FavoriteTableViewCell.nib(), forCellReuseIdentifier: FavoriteTableViewCell.identifier)
        table.dataSource = self
    }
}

extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: FavoriteTableViewCell.identifier,
            for: indexPath
        ) as? FavoriteTableViewCell {
            cell.configure(with: favorites[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
}
