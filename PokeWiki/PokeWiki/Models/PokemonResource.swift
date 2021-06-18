//
//  DataModel.swift
//  PokeWiki
//
//  Created by Manish Charhate on 17/06/21.
//

import Foundation

/**
 Contains list of `Resource` present in current page and links to previous and next page.
 */
struct PokemonResource: Codable {

    let results: [Resource]
    let next: String?
    let previous: String?
}
