//
//  User+UserNetworkModel.swift
//  tawkGit
//
//  Created by Nazmul Islam on 18/9/21.
//

import Foundation

extension User {
    convenience init(from networkModel: UserNetworkModel) {
        var avatar: Media?
        if let avatarURL = networkModel.avatarURL {
            avatar = Media(remoteURLStr: avatarURL)
        }

        self.init(
            id: networkModel.id,
            username: networkModel.login,
            avatar: avatar,
            hasNote: false
        )
    }
}
