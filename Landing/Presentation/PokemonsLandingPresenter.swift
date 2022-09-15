//
//  PokemonsLandingPresenter.swift
//  PokemonApp
//
//  Created by Natalia Goyes on 14/09/22.
//

import UIKit

protocol PokemonsLandingPresenterProtocol: AnyObject {
    func setViewController(_ viewController: PokemonsLandingViewControllerProtocol)
    func getTotalPokemonCount() -> Int
    func getPokemonInfo(for row: Int) -> PokemonToDisplay
    func requestPokemonInformation()
    func pokemonWasSelected(at row: Int)
}

class PokemonsLandingPresenter {
    
    enum Error: Swift.Error {
        case emptySearch, emptyCountry
    }
   
    weak var viewController: PokemonsLandingViewControllerProtocol?
    
    var listPokemonsUseCase : ListPokemonsUseCaseProtocol
    var pokemonSelectionUseCase : PokemonSelectionUseCaseProtocol
    
    var pokemonsInformation: [PokemonToDisplay] = []

    init(listPokemonsUseCase : ListPokemonsUseCaseProtocol, pokemonSelectionUseCase : PokemonSelectionUseCaseProtocol){
        self.listPokemonsUseCase = listPokemonsUseCase
        self.pokemonSelectionUseCase = pokemonSelectionUseCase
    }
    
    func saveSelectedPokemon(at row: Int) {
        let displayedPokemon = pokemonsInformation[row]
        pokemonSelectionUseCase.savePokemon(with: displayedPokemon)
    }
}

extension PokemonsLandingPresenter: PokemonsLandingPresenterProtocol {
   
    func setViewController(_ viewController: PokemonsLandingViewControllerProtocol){
        self.viewController = viewController
    }
    
    func requestPokemonInformation(){
        self.listPokemonsUseCase.execute { [weak self] pokemons in
            guard let self = self, let viewController = self.viewController else {
                return
            }
            self.pokemonsInformation = pokemons
            viewController.reloadView()
        } onError: { [weak self] errorThrown in
            guard let self = self, let viewController = self.viewController else {
                return
            }
            viewController.alertInitializationFailed()
        }
    }
    
    func getTotalPokemonCount() -> Int{
        return pokemonsInformation.count
    }
    
    func getPokemonInfo(for row: Int) -> PokemonToDisplay {
        return pokemonsInformation[row]
    }
    
    func pokemonWasSelected(at row: Int){
        self.saveSelectedPokemon(at: row)
        viewController?.setPokemonToSend(with: pokemonsInformation[row])
        viewController?.navigateToDetailedPokemon()
    }
}
