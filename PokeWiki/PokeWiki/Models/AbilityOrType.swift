//
//  AbilityOrType.swift
//  PokeWiki
//
//  Created by Manish Charhate on 19/06/21.
//

import Foundation

struct AbilityOrType: Codable {

    let pokemon: [PokemonsWithAbilityOrType]
}

struct PokemonsWithAbilityOrType: Codable {

    let pokemon: Resource
}
