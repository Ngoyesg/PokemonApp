//
//  ProductsAndThumbnailsProcessor.swift
//  MercadoLibre
//
//  Created by Natalia Goyes on 29/08/22.
//

import Foundation

protocol GetPreProcessedPokemonServiceProtocol: AnyObject {
    func getPokemonsToProcess(with pokemonsAPIResponse: PokemonsAPIResponse, onSuccess: @escaping ([PokemonToProcess])-> (Void), onError: @escaping (WebServiceError)->(Void))
}

class GetPreProcessedPokemonService {
    
    var pokemonsToReturn : [PokemonToProcess] = []
    
    let getSinglePokemonDetailsService: GetSinglePokemonDetailsServiceProtocol
    
    let dispatchGroup = DispatchGroup()
    let dipatchQueue = DispatchQueue(label: "Pokemons")
    var error = false
    
    init(getPokemonDetailsService: GetSinglePokemonDetailsServiceProtocol) {
        self.getSinglePokemonDetailsService = getPokemonDetailsService
    }
    
    func mapPokemon(from detailedInfo: PokemonDetailedInfo) -> PokemonToProcess {
        let abilities = detailedInfo.abilities.map { $0.ability.name }
        return PokemonToProcess(id: detailedInfo.id, abilities: abilities, name: detailedInfo.name, image: detailedInfo.sprites.picture)
    }
}

extension GetPreProcessedPokemonService: GetPreProcessedPokemonServiceProtocol {
    
    func getPokemonsToProcess(with pokemonsAPIResponse: PokemonsAPIResponse, onSuccess: @escaping ([PokemonToProcess])-> (Void), onError: @escaping (WebServiceError)->(Void)){
        
        pokemonsAPIResponse.results.forEach { pokemonRawData in
            dipatchQueue.async {
                self.dispatchGroup.enter()
                self.getSinglePokemonDetailsService.getPokemonDetails(from: pokemonRawData.url) {[weak self] pokemonDetailedInformation in
                    guard let self = self else {
                        return
                    }
                    let newPokemon = self.mapPokemon(from: pokemonDetailedInformation)
                    self.pokemonsToReturn.append(newPokemon)
                    self.dispatchGroup.leave()
                } onError: { [weak self] webRequestError in
                    guard let self = self else {
                        return
                    }
                    self.dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: dipatchQueue) {
            DispatchQueue.main.async {
                onSuccess(self.pokemonsToReturn)
            }
        }
    }
}
