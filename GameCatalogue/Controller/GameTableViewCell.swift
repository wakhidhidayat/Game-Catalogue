//
//  GameTableViewCell.swift
//  GameCatalogue
//
//  Created by Wahid Hidayat on 31/01/21.
//  Copyright © 2021 Wakhid Saiful Hidayat. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var genres: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var poster: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static let identifier = "GameCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "GameTableViewCell", bundle: nil)
    }
    
    func configure(with model: Game) {
        print(model.genres)
        self.poster.layer.cornerRadius = 8
        self.poster.clipsToBounds = true
        
        self.name.text = model.name
        self.rating.text = "\(model.rating) / 5"
        
        var genres = [String]()
        
        for genre in model.genres {
            genres.append(genre.name)
        }
        
        self.genres.text = genres.joined(separator: ", ")
        
        if let data = try? Data(contentsOf: URL(string: model.backgroundImage!)!) {
            self.poster.image = UIImage(data: data)
        }
    }
}
