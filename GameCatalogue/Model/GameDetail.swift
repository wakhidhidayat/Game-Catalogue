//
//  GameDetail.swift
//  GameCatalogue
//
//  Created by Wahid Hidayat on 01/02/21.
//  Copyright © 2021 Wakhid Saiful Hidayat. All rights reserved.
//

import Foundation

struct GameDetail: Codable {
    let id: Int
    let name: String
    let released: String?
    let backgroundImage: String?
    let backgroundImageAdditional: String?
    let rating: Double
    let description: String
    let genres: [Genre]
    
    struct Genre: Codable {
        let name: String
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case released
        case backgroundImage = "background_image"
        case backgroundImageAdditional = "background_image_additional"
        case rating
        case description
        case genres
    }
}
