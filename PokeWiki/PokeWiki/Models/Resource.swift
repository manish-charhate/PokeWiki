//
//  Resource.swift
//  PokeWiki
//
//  Created by Manish Charhate on 17/06/21.
//

import UIKit

/**
 A resource can be a pokemon, ability, type, move, etc.
 Contains name of the resource and a url to fetch the details of resource.
 */
struct Resource: Codable, Hashable {

    let name: String
    let url: String
}
