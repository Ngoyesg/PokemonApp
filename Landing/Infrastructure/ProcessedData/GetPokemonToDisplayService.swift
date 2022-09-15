//
//  GetPokemonToDisplayService.swift
//  PokemonApp
//
//  Created by Natalia Goyes on 14/09/22.
//

import Foundation

protocol GetPokemonToDisplayServiceProtocol: AnyObject {
    func getPokemonsToDisplay(with pokemonsToProcess: [PokemonToProcess], onSuccess: @escaping ([PokemonToDisplay])-> (Void), onError: @escaping (WebServiceError)->(Void))
}

class GetPokemonToDisplayService {
    
    var pokemonsToReturn : [PokemonToDisplay] = []
    
    let getPokemonImageService: GetPokemonImageServiceProtocol
    
    let dispatchGroup = DispatchGroup()
    let dipatchQueue = DispatchQueue(label: "PokemonImage")
    var error = false
    
    init(getPokemonImageService: GetPokemonImageServiceProtocol) {
        self.getPokemonImageService = getPokemonImageService
    }
    
    func mapPokemon(from detailedInfo: PokemonToProcess, and image: Data?) -> PokemonToDisplay {
        return PokemonToDisplay(id: "\(detailedInfo.id)", name: detailedInfo.name, image: image, abilities: detailedInfo.abilities)
    }
}

extension GetPokemonToDisplayService: GetPokemonToDisplayServiceProtocol {
    
    func getPokemonsToDisplay(with pokemonsToProcess: [PokemonToProcess], onSuccess: @escaping ([PokemonToDisplay])-> (Void), onError: @escaping (WebServiceError)->(Void)) {
        
//       error = false
        
        pokemonsToProcess.forEach { singlePokemonInfo in
            dipatchQueue.async {
                self.dispatchGroup.enter()
                guard let imageURL = singlePokemonInfo.image else {
                    self.dispatchGroup.leave()
                    let newPokemon = self.mapPokemon(from: singlePokemonInfo, and: nil)
                    self.pokemonsToReturn.append(newPokemon)
                    return
                }
                self.getPokemonImageService.getImage(from: imageURL) {[weak self] imageData in
                    guard let self = self else {
                        return
                    }
                    let newPokemon = self.mapPokemon(from: singlePokemonInfo, and: imageData)
                    self.pokemonsToReturn.append(newPokemon)
                    self.dispatchGroup.leave()
                } onError: { [weak self] webRequestError in
                    guard let self = self else {
                        return
                    }
                    self.dispatchGroup.leave()
//                    self.error = true
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
