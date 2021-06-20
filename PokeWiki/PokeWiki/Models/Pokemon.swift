//
//  Pokemon.swift
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
    let name: String

    // ID of the pokemon
    let id: Int

    // Abilities of the pokemon
    private let abilities: [Ability]

    // Types to which this pokemon belongs
    private let types: [Type]

    // Height of pokemon
    private let height: Int

    // Weight of pokemon
    private let weight: Int

    // Contains visual data related to the pokemon
    private let sprites: Sprites?

    // Stats of pokemon
    let stats: [Stat]

    // URL string for the image of this pokemon
    var imageURLString: String? {
        return sprites?.imageURLString
    }

    var capitalizedName: String {
        return name.capitalized
    }

    var abilitiesText: String {
        let array = abilities.map { $0.ability.name }
        return array.joined(separator: " | ")
    }

    var typesText: String {
        let array = types.map { $0.type.name }
        return array.joined(separator: " | ")
    }

    var idText: String {
        return "\(id)."
    }

    var heightText: String {
        return "\(height) \""
    }

    var weightText: String {
        return "\(weight) lbs"
    }

    var statsData: [String : Int] {
        var statsData = [String : Int]()
        stats.forEach { stat in
            statsData[stat.statInfo.name] = stat.baseStat
        }
        return statsData
    }
}

/**
 Contains visual data related to the pokemon.
 */
fileprivate struct Sprites: Codable {

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
