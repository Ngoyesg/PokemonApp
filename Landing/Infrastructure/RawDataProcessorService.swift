//
//  RawDataProcessorService.swift
//  PokemonApp
//
//  Created by Natalia Goyes on 14/09/22.
//

import Foundation

protocol RawDataProcessorServiceProtocol: AnyObject {
    func process(from apiResponse: PokemonsAPIResponse, onSuccess: @escaping ([PokemonToDisplay])->(Void), onError: @escaping (WebServiceError)->(Void))
}

class RawDataProcessorService {
    
    let getPreProcessedPokemonService : GetPreProcessedPokemonServiceProtocol
    let getPokemonsToDisplayService: GetPokemonToDisplayServiceProtocol
    
    init(getPreProcessedPokemonService : GetPreProcessedPokemonServiceProtocol, getPokemonsToDisplayService: GetPokemonToDisplayServiceProtocol) {
        self.getPreProcessedPokemonService = getPreProcessedPokemonService
        self.getPokemonsToDisplayService = getPokemonsToDisplayService
    }
    
    func getPokemonsToDisplay(from pokemonsToProcess: [PokemonToProcess] ,onSuccess: @escaping ([PokemonToDisplay])->(Void), onError: @escaping (WebServiceError)->(Void)){
        getPokemonsToDisplayService.getPokemonsToDisplay(with: pokemonsToProcess) { [weak self] pokemonsToDisplay in
            guard let self = self else {
                return
            }
            onSuccess(pokemonsToDisplay)
       } onError: { [weak self] errorThrown in
            guard let self = self else {
                return
            }
            onError(.searchFailed)
        }
    }
}

extension RawDataProcessorService: RawDataProcessorServiceProtocol {
    func process(from apiResponse: PokemonsAPIResponse, onSuccess: @escaping ([PokemonToDisplay])->(Void), onError: @escaping (WebServiceError)->(Void)) {
        getPreProcessedPokemonService.getPokemonsToProcess(with: apiResponse) { [weak self] pokemonsToProcess in
            guard let self = self else {
                return
            }
            self.getPokemonsToDisplay(from: pokemonsToProcess, onSuccess: onSuccess, onError: onError)
       } onError: { [weak self] errorThrown in
            guard let self = self else {
                return
            }
            onError(.searchFailed)
        }
    }
}
