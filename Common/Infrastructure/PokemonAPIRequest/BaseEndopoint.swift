//
//  BaseEndopoint.swift
//  PokemonApp
//
//  Created by Natalia Goyes on 13/09/22.
//

import Foundation

class BaseEndpoint {
    
    let scheme: String = "https"
    let host: String = "pokeapi.co"
    let path: String
    let queryItems: [URLQueryItem]
    let httpMethod: HTTPMethod
    
    init(path: String, queryItems: [URLQueryItem], httpMethod: HTTPMethod) {
        self.path = path
        self.queryItems = queryItems
        self.httpMethod = httpMethod
    }
    
    func getURL() -> URL? {
        
        var components = URLComponents()
        components.scheme = self.scheme
        components.host = self.host
        components.path = self.path
        components.queryItems = self.queryItems
        
       return components.url
    }
}

class AllPokemonsSearch: BaseEndpoint {
    
    struct Constant {
        static let limitIdentifier = "limit"
        static let offsetIdentifier = "offset"
        static let limit = "20"
        static let offset = "0"
    }
    
    init(){
        let path = "/api/v2/pokemon"
        let queryItems = [URLQueryItem(name: Constant.limitIdentifier, value: Constant.limit),URLQueryItem(name: Constant.offsetIdentifier, value: Constant.offset)]
        super.init(path: path, queryItems: queryItems, httpMethod: .GET)
    }
    
}

class PokemonSearch: BaseEndpoint {
    
    struct Constant {
        static let questIdentifier = "/"
    }
    
    init(pokemonId: String){
        let path = "/api/v2/pokemon"
        let queryItems = [URLQueryItem(name: Constant.questIdentifier, value: pokemonId)]
        super.init(path: path, queryItems: queryItems, httpMethod: .GET)
    }
}
