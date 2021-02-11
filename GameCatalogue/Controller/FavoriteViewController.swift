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
    var activityIndicator: UIActivityIndicatorView!
    private lazy var favoriteProvider: FavoriteProvider = { return FavoriteProvider() }()
    
    override func loadView() {
        super.loadView()
        
        activityIndicator = UIActivityIndicatorView(style: .medium)
        table.backgroundView = activityIndicator
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadFavorites()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func loadFavorites() {
        activityIndicator.startAnimating()
        table.separatorStyle = .none
        self.favoriteProvider.getFavorites { (result) in
            DispatchQueue.main.async {
                self.favorites = result
                self.table.separatorStyle = .singleLine
                self.table.reloadData()
            }
        }
    }

    private func setupView() {
        self.navigationItem.title = "Favorites"
        table.register(FavoriteTableViewCell.nib(), forCellReuseIdentifier: FavoriteTableViewCell.identifier)
        table.dataSource = self
        table.delegate = self
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

extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = DetailFavoriteViewController(nibName: "DetailFavoriteViewController", bundle: nil)
        detail.game = favorites[indexPath.row]
        self.navigationController?.pushViewController(detail, animated: true)
    }
}
