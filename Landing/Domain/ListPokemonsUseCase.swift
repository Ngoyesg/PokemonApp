//
//  ListPokemonsUseCase.swift
//  PokemonApp
//
//  Created by Natalia Goyes on 14/09/22.
//

import Foundation

protocol ListPokemonsUseCaseProtocol: AnyObject {
    func execute(onSuccess: @escaping ([PokemonToDisplay])->(Void), onError: @escaping (WebServiceError)->(Void))
}

class ListPokemonsUseCase {
    
    let getRawAPIResponseService: GetRawAPIResponseServiceProtocol
    let rawDataProcessorService: RawDataProcessorServiceProtocol
    
    init(getRawAPIResponseService: GetRawAPIResponseServiceProtocol, rawDataProcessorService: RawDataProcessorServiceProtocol) {
        self.getRawAPIResponseService = getRawAPIResponseService
        self.rawDataProcessorService = rawDataProcessorService
    }
    
    func processAPIResponse(from apiResponse: PokemonsAPIResponse ,onSuccess: @escaping ([PokemonToDisplay])->(Void), onError: @escaping (WebServiceError)->(Void)){
        rawDataProcessorService.process(from: apiResponse) { [weak self] pokemosToDisplay in
            guard let self = self else {
                return
            }
            onSuccess(pokemosToDisplay)
       } onError: { [weak self] errorThrown in
            guard let self = self else {
                return
            }
            onError(.searchFailed)
        }
    }
}

extension ListPokemonsUseCase :ListPokemonsUseCaseProtocol {
    func execute(onSuccess: @escaping ([PokemonToDisplay])->(Void), onError: @escaping (WebServiceError)->(Void)) {
        getRawAPIResponseService.getPokemonRawData { [weak self] pokemonsAPIResponse in
            guard let self = self else {
                return
            }
            self.processAPIResponse(from: pokemonsAPIResponse, onSuccess: onSuccess, onError: onError)
        } onError: { [weak self] errorThrown in
            guard let self = self else {
                return
            }
            onError(.searchFailed)
        }
    }
}
