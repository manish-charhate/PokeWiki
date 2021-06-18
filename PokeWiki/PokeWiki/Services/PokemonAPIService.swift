//
//  PokemonAPIService.swift
//  PokeWiki
//
//  Created by Manish Charhate on 17/06/21.
//

import Foundation

public typealias DataFetchHandler = ([Pokemon]?, Error?) -> Void

/**
 Provides services related to Pokemon API.
 */
final class PokemonAPIService {

    // MARK:- Private Properties

    private static var nextPageURLString: String?
    private static let pokemonResourceURLString = "https://pokeapi.co/api/v2/pokemon"

    // MARK:- Public APIs

    /**
     Fetches and returns initial page of `Pokemon`s.

     - parameter completionHandler: A block to be called when the fetch operation is finished so as to notify the caller.
     */
    static func fetchInitialData(with completionHandler: DataFetchHandler?) {
        fetchResource(with: PokemonAPIService.pokemonResourceURLString, completionHandler: completionHandler)
    }

    /**
     Fetches next page of `Pokemon`s if `URL` of next page is available.

     - parameter completionHandler: A block to be called when the fetch operation is finished so as to notify the caller.
     */
    static func loadMorePokemons(with completionHandler: DataFetchHandler?) {
        // Check if the URL of next page is available
        guard let nextPageURLString = nextPageURLString else {
            completionHandler?(nil, nil)
            return
        }

        fetchResource(with: nextPageURLString, completionHandler: completionHandler)
    }

    /**
     Fetches a `Pokemon` by name.

     - parameter name: Name of the pokemon
     - parameter completionHandler: A block to be called when the fetch operation is finished so as to notify the caller.
     */
    static func fetchPokemon(with name: String, completionHandler: @escaping (Pokemon?, Error?) -> Void) {
        guard let url = URL(string: pokemonResourceURLString) else {
            return
        }
        fetchPokemon(with: url.appendingPathComponent(name), completionHandler: completionHandler)
    }

    // MARK:- Private Helpers

    private static func fetchResource(with urlString: String, completionHandler: DataFetchHandler?) {
        guard let requestURL = URL(string: urlString) else {
            return
        }
        let dataTask = URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            guard let data = data else {
                completionHandler?(nil, error)
                return
            }
            if let pokemonResource = try? JSONDecoder().decode(PokemonResource.self, from: data) {
                nextPageURLString = pokemonResource.next

                var pokemons = [Pokemon]()
                let urls = pokemonResource.results.compactMap { URL(string: $0.url) }

                let group = DispatchGroup()

                for url in urls {
                    group.enter()
                    fetchPokemon(with: url) { pokemon, _ in
                        if let pokemon = pokemon {
                            pokemons.append(pokemon)
                        }
                        group.leave()
                    }
                }

                group.notify(queue: .main) {
                    completionHandler?(pokemons, nil)
                }
            }
        }
        dataTask.resume()
    }

    private static func fetchPokemon(with url: URL, completionHandler: @escaping (Pokemon?, Error?) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data else {
                return
            }
            if let pokemonDetails = try? JSONDecoder().decode(Pokemon.self, from: data) {
                completionHandler(pokemonDetails, error)
            }
        }
        dataTask.resume()
    }
}
