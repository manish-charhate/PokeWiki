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
    private static let baseURLString = "https://pokeapi.co/api/v2"
    private static let pokemon = "pokemon"
    private static let ability = "ability"
    private static let type = "type"
    private static let totalAbilities = 327

    // MARK:- Public APIs

    /**
     Fetches and returns initial page of `Pokemon`s.

     - parameter completionHandler: A block to be called when the fetch operation is finished so as to notify the caller.
     */
    static func fetchInitialData(with completionHandler: DataFetchHandler?) {
        let url = URL(string: baseURLString)!.appendingPathComponent(pokemon)
        fetchResource(with: url, completionHandler: completionHandler)
    }

    /**
     Fetches next page of `Pokemon`s if `URL` of next page is available.

     - parameter completionHandler: A block to be called when the fetch operation is finished so as to notify the caller.
     */
    static func loadMorePokemons(with completionHandler: DataFetchHandler?) {
        // Check if the URL of next page is available
        guard let nextPageURLString = nextPageURLString,
              let url = URL(string: nextPageURLString) else {
            completionHandler?(nil, nil)
            return
        }

        fetchResource(with: url, completionHandler: completionHandler)
    }

    /**
     Fetches a `Pokemon` by name.

     - parameter name: Name of the pokemon
     - parameter completionHandler: A block to be called when the fetch operation is finished so as to notify the caller.
     */
    static func fetchPokemon(with name: String, completionHandler: @escaping (Pokemon?, Error?) -> Void) {
        let url = URL(string: baseURLString)!.appendingPathComponent(pokemon)
        fetchPokemon(with: url.appendingPathComponent(name), completionHandler: completionHandler)
    }

    static func fetchAbilities(with completionHandler: @escaping ([Resource]?) -> Void) {
        var urlComponents = URLComponents(string: baseURLString + "/" + ability)!
        urlComponents.queryItems = [
            URLQueryItem(name: "offset", value: "0"),
            URLQueryItem(name: "limit", value: "\(totalAbilities)")
        ]
        guard let url = urlComponents.url else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completionHandler(nil)
                return
            }
            if let resourceCollection = try? JSONDecoder().decode(ResourceCollection.self, from: data) {
                completionHandler(resourceCollection.results)
            }
        }.resume()
    }

    static func fetchTypes(with completionHandler: @escaping ([Resource]?) -> Void) {
        let url = URL(string: baseURLString)!.appendingPathComponent(type)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completionHandler(nil)
                return
            }
            if let resourceCollection = try? JSONDecoder().decode(ResourceCollection.self, from: data) {
                completionHandler(resourceCollection.results)
            }
        }.resume()
    }

    static func fetchPokemonsByAbilityOrType(with urlString: String, handler: @escaping ([Pokemon]?) -> Void) {
        guard let url = URL(string: urlString) else {
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                handler(nil)
                return
            }

            var pokemons = [Pokemon]()
            if let abilityOrType = try? JSONDecoder().decode(AbilityOrType.self, from: data) {
                let group = DispatchGroup()

                abilityOrType.pokemon.forEach { (pokemon) in
                    guard let url = URL(string: pokemon.pokemon.url) else {
                        return
                    }

                    group.enter()
                    URLSession.shared.dataTask(with: url) { (data, response, error) in
                        guard let data = data else {
                            return
                        }

                        if let pokemon = try? JSONDecoder().decode(Pokemon.self, from: data) {
                            pokemons.append(pokemon)
                        }

                        group.leave()
                    }.resume()
                }

                group.notify(queue: .main) {
                    handler(pokemons)
                }
            }
        }.resume()
    }

    // MARK:- Private Helpers

    private static func fetchResource(with url: URL, completionHandler: DataFetchHandler?) {
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
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
