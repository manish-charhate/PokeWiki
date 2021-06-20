//
//  HomeViewModel.swift
//  PokeWiki
//
//  Created by Manish Charhate on 17/06/21.
//

import Foundation

protocol ViewModelDelegate: class {

    func didLoadData()
}

/**
 View model for the `HomeViewController`
 */
class HomeViewModel {

    /**
     Describes the sort method for sorting the collection.
     */
    enum SortBy {
        case name
        case id
    }

    // MARK:- Properties

    private(set) var pokemons = [Pokemon]()
    private(set) var filteredPokemons = [Pokemon]()
    private var abilities = Set<Resource>([])
    private var types = Set<Resource>([])
    weak var delegate: ViewModelDelegate?

    init() {
        loadInitialData()
    }

    func loadInitialData() {
        PokemonAPIService.fetchInitialData { [weak self] pokemons, error in
            if error != nil {
                return
            }

            guard let pokemons = pokemons else {
                return
            }

            self?.pokemons.append(contentsOf: pokemons)
            self?.filteredPokemons = pokemons
            self?.delegate?.didLoadData()
        }

        DispatchQueue.global(qos: .background).async {
            PokemonAPIService.fetchAbilities { [weak self] abilities in
                guard let abilities = abilities else {
                    return
                }
                self?.abilities = Set(abilities)
            }

            PokemonAPIService.fetchTypes { [weak self] types in
                guard let types = types else {
                    return
                }
                self?.types = Set(types)
            }
        }
    }

    func loadMore() {
        PokemonAPIService.loadMorePokemons { [weak self] pokemons, error in
            if error != nil {
                return
            }

            guard let pokemons = pokemons else {
                return
            }

            self?.pokemons.append(contentsOf: pokemons)
            self?.filteredPokemons.append(contentsOf: pokemons)
            self?.delegate?.didLoadData()
        }
    }

    func sortData(by approach: SortBy) {
        switch approach {
        case .id:
            filteredPokemons.sort { $0.id < $1.id }
        case .name:
            filteredPokemons.sort { $0.name < $1.name }
        }

        delegate?.didLoadData()
    }

    func searchPokemons(by searchText: String, handler: @escaping () -> Void) {
        if let abilityURLString = abilities.filter({ $0.name == searchText }).first?.url {
            PokemonAPIService.fetchPokemonsByAbilityOrType(with: abilityURLString) { [weak self] pokemons in
                guard let pokemons = pokemons else {
                    return
                }
                self?.filteredPokemons = pokemons
                handler()
            }
        }

        if let typeURLString = types.filter({ $0.name == searchText }).first?.url {
            PokemonAPIService.fetchPokemonsByAbilityOrType(with: typeURLString) { [weak self] pokemons in
                guard let pokemons = pokemons else {
                    return
                }
                self?.filteredPokemons = pokemons
                handler()
            }
        }

        PokemonAPIService.fetchPokemon(with: searchText) { [weak self] pokemon, _ in
            guard let pokemon = pokemon else {
                return
            }
            self?.filteredPokemons = [pokemon]
            handler()
        }
    }

    func resetData() {
        filteredPokemons = pokemons
        delegate?.didLoadData()
    }

}
