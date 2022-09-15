//
//  WebClientProtocol.swift
//  PokemonApp
//
//  Created by Natalia Goyes on 13/09/22.
//


import Foundation

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

enum WebServiceError: Error {
    case noURLFound, noEndpointFound,invalidRequest, invalidStatusCodeResponse, noDataToDecode, errorDecodingData, errorEncodingData, searchFailed
}

protocol WebClientProtocol {
    func performRequest(request: URLRequest, onSuccess: @escaping (Data) -> Void, onError: @escaping (WebServiceError) -> Void)
}
