//
//  PokemonSelectionUseCase.swift
//  PokemonApp
//
//  Created by Natalia Goyes on 14/09/22.
//

import Foundation

protocol PokemonSelectionUseCaseProtocol: AnyObject {
    func savePokemon(with pokemonToSave: PokemonToDisplay)
}

class PokemonSelectionUseCase{
    
    var countriesData : [PokemonsAPIResponse] = []
    
    let pokemonSelectionManager: PokemonSelectionManager
    
    init(pokemonSelectionManager: PokemonSelectionManager) {
        self.pokemonSelectionManager = pokemonSelectionManager
    }
}

extension PokemonSelectionUseCase: PokemonSelectionUseCaseProtocol {
    
    func savePokemon(with pokemonToSave: PokemonToDisplay){
        self.pokemonSelectionManager.savePokemon(with: pokemonToSave)
    }
}
