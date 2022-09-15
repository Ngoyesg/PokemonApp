//
//  GetSinglePokemonDetailsService.swift
//  PokemonApp
//
//  Created by Natalia Goyes on 13/09/22.
//

import Foundation

protocol GetSinglePokemonDetailsServiceProtocol: AnyObject {
    func getPokemonDetails(from text: String, onSuccess: @escaping (PokemonDetailedInfo) -> Void, onError: @escaping (WebServiceError) -> Void)
}

class GetSinglePokemonDetailsService {
    
    enum Error: Swift.Error {
        case URLRequestError, webClientError
    }
    
    let restClient: WebClientProtocol
    
    init(restClient: WebClientProtocol) {
        self.restClient = restClient
    }
    
    func processResponse(
        responseToDecode: Data,
        onSuccess: @escaping (PokemonDetailedInfo) -> Void,
        onError: @escaping (WebServiceError) -> Void) {
            
            let decoder = JSONDecoder()
            
            do {
                let decodifiedResponse = try decoder.decode(PokemonDetailedInfo.self, from: responseToDecode)
                onSuccess(decodifiedResponse)
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
                onError(.errorDecodingData)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                onError(.errorDecodingData)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                onError(.errorDecodingData)
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
                onError(.errorDecodingData)
            } catch {
                print("error: ", error)
                onError(.errorDecodingData)
            }
        }
    
    func performRequest(request: URLRequest, onSuccess: @escaping (PokemonDetailedInfo) -> Void, onError: @escaping (WebServiceError) -> Void) {
        restClient.performRequest(request: request) { [weak self] dataToDecode in
            guard let self = self else {
                return
            }
            self.processResponse(responseToDecode: dataToDecode, onSuccess: onSuccess, onError: onError)
        } onError: {  [weak self] errorThrown in
            guard let self = self else {
                return
            }
            onError(errorThrown)
        }
    }
    
}

extension GetSinglePokemonDetailsService: GetSinglePokemonDetailsServiceProtocol {
    
    func getPokemonDetails(from text: String, onSuccess: @escaping (PokemonDetailedInfo) -> Void, onError: @escaping (WebServiceError) -> Void) {
        
        do {
            let urlToRequest = try URLRequest(url: URL(string: text)!)
            performRequest(request: urlToRequest, onSuccess: onSuccess, onError: onError)
        } catch let errorThrown {
            onError(.searchFailed)
        }
    }
}


