//
//  PreconditionVerifierUseCase.swift
//  PokemonApp
//
//  Created by Natalia Goyes on 14/09/22.
//

import Foundation

protocol PreconditionVerifierUseCaseProtocol: AnyObject {
    func getPreconditions(onSuccess: @escaping (PokemonForTransfer)-> (Void), onError: @escaping (PokemonSelectionManager.Error)->(Void))
}

class PreconditionVerifierUseCase {
    
    let pokemonSelectionManager: PokemonSelectionManagerProtocol
    
    init(pokemonSelectionManager: PokemonSelectionManagerProtocol) {
        self.pokemonSelectionManager = pokemonSelectionManager
    }
}

extension PreconditionVerifierUseCase: PreconditionVerifierUseCaseProtocol {
    func getPreconditions(onSuccess: @escaping (PokemonForTransfer)-> (Void), onError: @escaping (PokemonSelectionManager.Error)->(Void)) {
        do {
            let id = try self.pokemonSelectionManager.getPokemonId()
            let name = try self.pokemonSelectionManager.getPokemonName()
            let image = self.pokemonSelectionManager.getPokemonImage()
            let ability1 = self.pokemonSelectionManager.getAbility1()
            let ability2 = self.pokemonSelectionManager.getAbility2()
            let ability3 = self.pokemonSelectionManager.getAbility3()
            let returnablePokemon = PokemonForTransfer(id: id, name: name, image: image, ability1: ability1, ability2: ability2, ability3: ability3)
            onSuccess(returnablePokemon)
        } catch {
            onError(.noPokemon)
        }
    }
}
