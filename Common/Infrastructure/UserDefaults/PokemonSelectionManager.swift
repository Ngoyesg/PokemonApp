//
//  PokemonSelectionManager.swift
//  PokemonApp
//
//  Created by Natalia Goyes on 13/09/22.
//

import Foundation

protocol PokemonSelectionManagerProtocol: AnyObject {
    func savePokemon(with pokemonInfo: PokemonToDisplay)
    func getPokemonImage() -> Data?
    func getAbility1() -> String?
    func getAbility2() -> String?
    func getAbility3() -> String?
    func getPokemonId() throws -> String
    func getPokemonName() throws -> String 
}

class PokemonSelectionManager {
    
    struct Constant {
        static let pokemonId = "pokemonId"
        static let pokemonName = "pokemonName"
        static let pokemonImage = "pokemonImage"
        static let pokemonAbility1 = "pokemonAbility1"
        static let pokemonAbility2 = "pokemonAbility2"
        static let pokemonAbility3 = "pokemonAbility3"
    }
    
    enum Error: Swift.Error {
        case noPokemon
    }
    
    let store = UserDefaults.standard
}
    
extension PokemonSelectionManager: PokemonSelectionManagerProtocol {
    
    func savePokemon(with pokemonInfo: PokemonToDisplay) {
        let store = UserDefaults.standard
        store.set(pokemonInfo.id, forKey: Constant.pokemonId)
        store.set(pokemonInfo.name, forKey: Constant.pokemonName)
        store.set(pokemonInfo.image, forKey: Constant.pokemonImage)
        
        let abilities = pokemonInfo.abilities
        switch abilities.count {
        case 1:
            store.set(abilities[0], forKey: Constant.pokemonAbility1)
        case 2:
            store.set(abilities[0], forKey: Constant.pokemonAbility1)
            store.set(abilities[1], forKey: Constant.pokemonAbility2)
        case 3:
            store.set(abilities[0], forKey: Constant.pokemonAbility1)
            store.set(abilities[1], forKey: Constant.pokemonAbility2)
            store.set(abilities[2], forKey: Constant.pokemonAbility3)
        default:
            fatalError()
        }
        
    }
    
    func getPokemonId() throws -> String  {
        let id = store.value(forKey: Constant.pokemonId) as? Int
        if let id = id{
            return "\(id)"
        } else {
            throw PokemonSelectionManager.Error.noPokemon
        }
    }
    func getPokemonName() throws -> String  {
        let name = store.value(forKey: Constant.pokemonName) as? String
        if let name = name{
            return name
        } else {
            throw PokemonSelectionManager.Error.noPokemon
        }
    }
    func getPokemonImage() -> Data?  {
        return store.value(forKey: Constant.pokemonImage) as? Data ?? nil
    }
    func getAbility1() -> String? {
        return  store.value(forKey: Constant.pokemonAbility1) as? String ?? nil
    }
    func getAbility2() -> String? {
        return  store.value(forKey: Constant.pokemonAbility2) as? String ?? nil
    }
    func getAbility3() -> String? {
        return  store.value(forKey: Constant.pokemonAbility3) as? String ?? nil
    }
    
}
