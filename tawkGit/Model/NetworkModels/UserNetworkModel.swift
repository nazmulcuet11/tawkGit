//
//  Model.swift
//  tawkGit
//
//  Created by Nazmul Islam on 17/9/21.
//

import Foundation

struct UserNetworkModel: Decodable {
    let id: Int
    let login: String
    let avatarURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarURL = "avatar_url"
    }
}

typealias UserListNetworkModel = [UserNetworkModel]
