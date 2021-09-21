//
//  UserCellViewModel.swift
//  tawkGit
//
//  Created by Nazmul Islam on 21/9/21.
//

import Foundation

struct UserCellViewModel {
    var name: String { user.username }
    var details: String { "Id: \(user.id)" }
    var avatarURL: String? { user.avatarURL }
    var invertAvatarColor: Bool { (index + 1) % 4 == 0}
    var hasNote: Bool { user.note != nil }
    var profileVisited: Bool { user.profileVisited }

    let user: User
    let index: Int

    init(with user: User, index: Int) {
        self.user = user
        self.index = index
    }
}
