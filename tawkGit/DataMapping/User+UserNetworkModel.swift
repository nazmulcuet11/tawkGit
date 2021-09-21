//
//  User+UserNetworkModel.swift
//  tawkGit
//
//  Created by Nazmul Islam on 18/9/21.
//

import Foundation

extension User {
    func hasDifference(with networkModel: UserNetworkModel) -> Bool {
        return id != networkModel.id
            || username != networkModel.login
            || avatarURL != networkModel.avatarURL
    }

    func transferChanges(from networkModel: UserNetworkModel) {
        id = networkModel.id
        username = networkModel.login
        avatarURL = networkModel.avatarURL
    }
}
