//
//  DetailedItemPresenterBuilder.swift
//  PokemonApp
//
//  Created by Natalia Goyes on 14/09/22.
//


import Foundation

class DetailedPokemonPresenterBuilder {
    
    func build() -> DetailedPokemonPresenterProtocol {
    
        let pokemonSelectionManager = PokemonSelectionManager()
        
        let preconditionVerifierUseCase = PreconditionVerifierUseCase(pokemonSelectionManager: pokemonSelectionManager)
        
        return DetailedPokemonPresenter(preconditionVerifierUseCase: preconditionVerifierUseCase)
    }
    
}
