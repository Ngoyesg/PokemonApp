
import Foundation

struct PokemonToProcess: Codable, Equatable {
    let id: Int
    let abilities: [String]
    let name: String
    let image: String?
}

struct PokemonToDisplay: Equatable {
    let id: String
    let name: String
    let image: Data?
    let abilities: [String?]
}
