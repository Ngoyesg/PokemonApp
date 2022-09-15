//
//  ItemToSearchManager.swift
//  PokemonApp
//
//  Created by Natalia Goyes on 13/09/22.
//

import Foundation

protocol ItemToSearchManagerProtocol: AnyObject {
    func saveItem(with description: String)
    func getItem() throws -> String
}

class ItemToSearchManager {
    
    struct Constant {
        static let userDefaultItemToSearch = "itemToSearch"
    }
    
    enum Error: Swift.Error {
        case noItemToSearch
    }
}

extension ItemToSearchManager: ItemToSearchManagerProtocol {
    
    func saveItem(with description: String) {
        let store = UserDefaults.standard
        store.set(description, forKey: Constant.userDefaultItemToSearch)
    }
    
    func getItem() throws -> String {
        let store = UserDefaults.standard
        let title = store.value(forKey: Constant.userDefaultItemToSearch) as? String
        
        if let title = title {
            return title
        } else {
            throw ItemToSearchManager.Error.noItemToSearch
        }
    }
    
}
