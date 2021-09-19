//
//  User+UserNetworkModel.swift
//  tawkGit
//
//  Created by Nazmul Islam on 18/9/21.
//

import Foundation

extension User {
    convenience init(from networkModel: UserNetworkModel) {
        self.init(
            id: networkModel.id,
            username: networkModel.login,
            avatarURL: networkModel.avatarURL,
            note: nil
        )
    }
}
