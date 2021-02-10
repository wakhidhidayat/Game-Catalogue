//
//  FavoriteTableViewCell.swift
//  GameCatalogue
//
//  Created by Wahid Hidayat on 09/02/21.
//  Copyright © 2021 Wakhid Saiful Hidayat. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet var poster: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var released: UILabel!
    @IBOutlet var rating: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static let identifier = "FavoriteCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "FavoriteTableViewCell", bundle: nil)
    }
    
    func configure(with model: Game) {
        self.poster.layer.cornerRadius = 8
        self.poster.clipsToBounds = true
        self.name.text = model.name
        self.rating.text = "\(model.rating) / 5"
        self.released.text = Util.formatDate(from: model.released)
        
        if let data = try? Data(contentsOf: URL(string: model.backgroundImage!)!) {
            self.poster.image = UIImage(data: data)
        }
    }
}
