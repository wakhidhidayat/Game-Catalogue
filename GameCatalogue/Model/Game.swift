//
//  Game.swift
//  GameCatalogue
//
//  Created by Wahid Hidayat on 31/01/21.
//  Copyright © 2021 Wakhid Saiful Hidayat. All rights reserved.
//

import UIKit

struct GameResult: Codable {
    let games: [Game]
    
    enum CodingKeys: String, CodingKey {
        case games = "results"
    }
}

struct Game: Codable {
    let id: Int
    let name: String
    let backgroundImage: String?
    let rating: Double
    let released: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case backgroundImage = "background_image"
        case rating
        case released
    }
}
