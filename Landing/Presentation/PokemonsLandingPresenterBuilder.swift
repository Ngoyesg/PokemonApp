//
//  PokemonsLandingPresenterBuilder.swift
//  PokemonApp
//
//  Created by Natalia Goyes on 14/09/22.
//

import Foundation

class PokemonsLandingPresenterBuilder {

    func build() -> PokemonsLandingPresenter {
        
        let restClient = RESTClient()

        let urlRequestBuilder = URLRequestBuilder()

        let getRawAPIResponseService = GetRawAPIResponseService(urlRequestBuilder: urlRequestBuilder, restClient: restClient)
        
        let getPokemonDetailsService = GetSinglePokemonDetailsService(restClient: restClient)
        
        let getPreProcessedPokemonService = GetPreProcessedPokemonService(getPokemonDetailsService: getPokemonDetailsService)
        
        let getPokemonImageService = GetPokemonImageService(restClient: restClient)
        
        let getPokemonsToDisplayService = GetPokemonToDisplayService(getPokemonImageService: getPokemonImageService)
        
        let rawDataProcessorService = RawDataProcessorService(getPreProcessedPokemonService: getPreProcessedPokemonService, getPokemonsToDisplayService: getPokemonsToDisplayService)
        
        let listPokemonsUseCase =  ListPokemonsUseCase(getRawAPIResponseService: getRawAPIResponseService, rawDataProcessorService: rawDataProcessorService)
        
        let pokemonSelectionManager = PokemonSelectionManager()
        
        let pokemonSelectionUseCase = PokemonSelectionUseCase(pokemonSelectionManager: pokemonSelectionManager)
        
        return PokemonsLandingPresenter(listPokemonsUseCase: listPokemonsUseCase, pokemonSelectionUseCase: pokemonSelectionUseCase)
    }

}
