//
//  GetPokemonImageService.swift
//  PokemonApp
//
//  Created by Natalia Goyes on 13/09/22.
//

import Foundation

protocol GetPokemonImageServiceProtocol: AnyObject {
    func getImage(from text: String, onSuccess: @escaping (Data) -> Void, onError: @escaping (WebServiceError) -> Void)
}

class GetPokemonImageService {
    
    enum Error: Swift.Error {
        case URLRequestError, webClientError
    }
    
    let restClient: WebClientProtocol
    
    init(restClient: WebClientProtocol) {
        self.restClient = restClient
    }
}

extension GetPokemonImageService: GetPokemonImageServiceProtocol {
    
    func getImage(from text: String, onSuccess: @escaping (Data) -> Void, onError: @escaping (WebServiceError) -> Void) {
        
        let urlRequest = URLRequest(url: URL(string: text)!)
        
        restClient.performRequest(request: urlRequest) { [weak self] dataFromRequest in
            guard let self = self else {
                return
            }
            onSuccess(dataFromRequest)
        } onError: {  [weak self] errorThrown in
            guard let self = self else {
                return
            }
            onError(errorThrown)
        }
    }
}

