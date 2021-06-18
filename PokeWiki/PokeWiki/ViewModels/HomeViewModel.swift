//
//  HomeViewModel.swift
//  PokeWiki
//
//  Created by Manish Charhate on 17/06/21.
//

import Foundation

class HomeViewModel {

    var dataFetchCompletionHandler: DataFetchHandler?
    private var nextPageURLString: String?

    func loadInitialData() {
        PokemonAPIService.fetchInitialData(with: dataFetchCompletionHandler)
    }

    func loadMore() {
        PokemonAPIService.loadMorePokemons(with: dataFetchCompletionHandler)
    }

    func searchPokemon(with name: String, handler: @escaping (Pokemon?, Error?) -> Void) {
        PokemonAPIService.fetchPokemon(with: name, completionHandler: handler)
    }

}
