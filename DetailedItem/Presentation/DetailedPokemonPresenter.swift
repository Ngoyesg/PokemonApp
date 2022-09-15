//
//  DetailedPokemonPresenter.swift
//  PokemonApp
//
//  Created by Natalia Goyes on 14/09/22.
//

import Foundation

protocol DetailedPokemonPresenterProtocol: AnyObject {
    func setViewController(_ viewController: DetailedPokemonViewController)
    func retrieveSelectedPokemon()
}

class DetailedPokemonPresenter {

    weak var viewController: DetailedPokemonViewController?

    var pokemonToDisplay: PokemonForTransfer?

    var preconditionVerifierUseCase: PreconditionVerifierUseCaseProtocol

    init(preconditionVerifierUseCase: PreconditionVerifierUseCaseProtocol){
        self.preconditionVerifierUseCase = preconditionVerifierUseCase
    }
}

extension DetailedPokemonPresenter: DetailedPokemonPresenterProtocol {
    
    func setViewController(_ viewController: DetailedPokemonViewController){
        self.viewController = viewController
    }
    
    func retrieveSelectedPokemon() {
        viewController?.fillViewElements(with: viewController?.pokemon)
    }
    
}
