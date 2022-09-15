//
//  PokemonsLandingViewController.swift
//  PokemonApp
//
//  Created by Natalia Goyes on 14/09/22.
//

import UIKit

protocol PokemonsLandingViewControllerProtocol: AnyObject {
    func alertSearchFailed()
    func alertInitializationFailed()
    func navigateToDetailedPokemon()
    func reloadView()
    func setPokemonToSend(with pokemon: PokemonToDisplay)
}

class PokemonsLandingViewController: UIViewController {
    
    struct Constant {
        static let alertSearchFailedTitle = "Search Failed"
        static let alertSearchFailedTitleMessage = "Unable to download the pokemons"
        static let alertInitializationFailedTitle = "Error"
        static let alertInitializationFailedTitleMessage = "Initialization Failed"
        static let okAction = "OK"
        static let cellIdentifier = "pokemonCell"
        static let segueToDetailedPokemon = "toDetailedPokemon"
    }
    
    var presenter: PokemonsLandingPresenterProtocol?
    var pokemonToSend: PokemonToDisplay?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        do {
            self.presenter = try PokemonsLandingPresenterBuilder().build()
            self.presenter?.setViewController(self)
        } catch {
            alertInitializationFailed()
        }
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.presenter?.requestPokemonInformation()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension PokemonsLandingViewController: PokemonsLandingViewControllerProtocol {
    
    func navigateToDetailedPokemon() {
        self.performSegue(withIdentifier: Constant.segueToDetailedPokemon, sender: self)
    }
    
    func alertInitializationFailed(){
        let alert = UIAlertController(title: Constant.alertInitializationFailedTitle, message: Constant.alertInitializationFailedTitleMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constant.okAction, style: .default, handler: { _ in fatalError()})
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    func alertSearchFailed(){
        let alert = UIAlertController(title: Constant.alertSearchFailedTitle, message: Constant.alertSearchFailedTitleMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constant.okAction, style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailedPokemonViewController {
            if let pokemonsent = self.pokemonToSend {
                destination.pokemon = pokemonsent
            }
        }
    }
    
    func setPokemonToSend(with pokemon: PokemonToDisplay) {
        self.pokemonToSend = pokemon
    }
    
}

extension PokemonsLandingViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getTotalPokemonCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellIdentifier, for: indexPath)
        let pokemonInfo = presenter?.getPokemonInfo(for: indexPath.row)
    
        if let pokemonInfo = pokemonInfo, let image = pokemonInfo.image {
            cell.imageView?.image = UIImage(data: image)
        } else {
            cell.imageView?.image = #imageLiteral(resourceName: "errorImage.jpg")
        }
        cell.textLabel?.text = pokemonInfo?.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.pokemonWasSelected(at: indexPath.row)
    }
  
    func reloadView(){
        tableView.reloadData()
    }
}
