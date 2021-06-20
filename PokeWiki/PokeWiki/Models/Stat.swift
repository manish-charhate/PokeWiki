//
//  Stat.swift
//  PokeWiki
//
//  Created by Manish Charhate on 20/06/21.
//

import Foundation

struct Stat: Codable {
    let baseStat: Int
    let statInfo: Resource

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case statInfo = "stat"
    }
}
