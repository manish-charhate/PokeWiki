//
//  PokemonDetails.swift
//  PokeWiki
//
//  Created by Manish Charhate on 17/06/21.
//

import Foundation

/**
 Gives details about a pokemon.
 */
public struct Pokemon: Codable {

    // Name of the pokemon
    let name: String?

    // ID of the pokemon
    let id: Int?

    // Contains visual data related to the pokemon
    private let sprites: Sprites?

    // URL string for the image of this pokemon
    var imageURLString: String? {
        return sprites?.imageURLString
    }

}

/**
 Contains visual data related to the pokemon.
 */
struct Sprites: Codable {

    // URL string of image by official artwork
    var imageURLString: String? {
        return other?.officialArtwork?.front_default
    }

    // Sprites other than default
    private let other: OtherSprites?

    // Sprites other than default
    struct OtherSprites: Codable {
        let officialArtwork: OfficialArtwork?

        // Set of image urls by official artwork
        struct OfficialArtwork: Codable {
            let front_default: String?
        }

        enum CodingKeys: String, CodingKey {
            case officialArtwork = "official-artwork"
        }
    }
}
