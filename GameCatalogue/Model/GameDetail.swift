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
    let rating: Double
    let description: String
    let platforms: [Platform]
    let genres: [Genre]
    
    struct Platform: Codable {
        let platform: PlatformName
        
        struct PlatformName: Codable {
            let name: String
        }
    }
    
    struct Genre: Codable {
        let name: String
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case released
        case backgroundImage = "background_image"
        case rating
        case description
        case platforms
        case genres
    }
}
