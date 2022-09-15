//
//  PokemonsAPIResponse.swift
//  PokemonApp
//
//  Created by Natalia Goyes on 13/09/22.
//

import Foundation

struct PokemonsAPIResponse: Codable, Equatable {
    let results: [PokemonRawData]
}

struct PokemonRawData: Codable, Equatable {
    let name: String
    let url: String
}

struct PokemonDetailedInfo: Codable, Equatable {
    let abilities: [SingleAbility]
    let sprites: Sprite
    let name: String
    let id: Int
}

struct SingleAbility: Codable, Equatable {
    let ability: IndividualAbility
    let isHidden: Bool
    let slot: Int
    
    private enum CodingKeys: String, CodingKey {
        case isHidden = "is_hidden", slot, ability
    }
}

struct IndividualAbility: Codable, Equatable {
    let name: String
    let url: String
}


struct Sprite: Codable, Equatable {
    let picture: String?
    
    private enum CodingKeys: String, CodingKey {
        case picture = "front_default"
    }
}


