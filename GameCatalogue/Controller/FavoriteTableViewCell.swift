//
//  FavoriteTableViewCell.swift
//  GameCatalogue
//
//  Created by Wahid Hidayat on 09/02/21.
//  Copyright © 2021 Wakhid Saiful Hidayat. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var released: UILabel!
    @IBOutlet weak var rating: UILabel!
    
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
    
    func configure(with model: FavoriteModel) {
        self.poster.layer.cornerRadius = 8
        self.poster.clipsToBounds = true
        self.name.text = model.name
        self.rating.text = "\(model.rating!) / 5"
        self.released.text = model.released
        self.poster.image = UIImage(data: model.backgroundImage!)
    }
}
