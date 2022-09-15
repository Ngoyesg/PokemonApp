//
//  DetailedPokemonViewController.swift
//  PokemonApp
//
//  Created by Natalia Goyes on 14/09/22.
//

import UIKit

protocol DetailedPokemonViewControllerProtocol: AnyObject {
    func alertInitializationFailed()
    func fillViewElements(with pokemonInfo: PokemonToDisplay?)
}

class DetailedPokemonViewController: UIViewController {
    
    var presenter: DetailedPokemonPresenterProtocol?
    var pokemon: PokemonToDisplay?
  
    struct Constant {
        static let alertInitializationFailedTitle = "Error"
        static let alertInitializationFailedTitleMessage = "Initialization Failed"
        static let okAction = "Ok"
    }
    
    @IBOutlet weak var pokemonName: UILabel!
    
    @IBOutlet weak var pokemonImage: UIImageView!
    
    @IBOutlet weak var pokemonAbility1: UILabel!
    
    @IBOutlet weak var pokemonAbility2: UILabel!
    
    @IBOutlet weak var pokemonAbility3: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            self.presenter = DetailedPokemonPresenterBuilder().build()
            self.presenter?.setViewController(self)
        } catch {
            alertInitializationFailed()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.presenter?.retrieveSelectedPokemon()
    }
    
    func setName(with name: String) {
        self.pokemonName.text = name
    }
    
    func setImage(with data: Data?) {
        if let data = data {
            self.pokemonImage.image = UIImage(data: data)
        } else {
            self.pokemonImage.image = #imageLiteral(resourceName: "errorImage")
        }
    }
    
    func setAbilities(with abilities: [String?]){
        switch abilities.count {
        case 1:
            self.pokemonAbility1.text = abilities[0]
            pokemonAbility2.isHidden = true
            pokemonAbility3.isHidden = true
        case 2:
            self.pokemonAbility1.text = abilities[0]
            self.pokemonAbility2.text = abilities[1]
            pokemonAbility3.isHidden = true
        case 3:
            self.pokemonAbility1.text = abilities[0]
            self.pokemonAbility2.text = abilities[1]
            self.pokemonAbility3.text = abilities[2]
        default:
            fatalError()
        }
    }
    
}

extension DetailedPokemonViewController: DetailedPokemonViewControllerProtocol {
    
    func alertInitializationFailed(){
        let alert = UIAlertController(title: Constant.alertInitializationFailedTitle, message: Constant.alertInitializationFailedTitleMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constant.okAction, style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    
    func fillViewElements(with pokemonInfo: PokemonToDisplay?) {
        guard let pokemonInfo = pokemonInfo else {
            alertInitializationFailed()
            return
        }
        self.setName(with: pokemonInfo.name)
        self.setImage(with: pokemonInfo.image)
        self.setAbilities(with: pokemonInfo.abilities)
    }
}
