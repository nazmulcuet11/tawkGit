//
//  UserProfileNetworkModel.swift
//  tawkGit
//
//  Created by Nazmul Islam on 17/9/21.
//

import Foundation

struct UserProfileNetworkModel: Decodable {
    let id: Int
    let login: String
    let avatarURL: String
    let followers: Int
    let following: Int
    let name: String
    let company: String
    let blog: String
    let location: String

    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarURL = "avatar_url"
        case followers
        case following
        case name
        case company
        case blog
        case location
    }
}
