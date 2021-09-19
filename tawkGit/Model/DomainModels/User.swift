//
//  User.swift
//  tawkGit
//
//  Created by Nazmul Islam on 18/9/21.
//

import Foundation

class User: Hashable {

    var id: Int
    var username: String
    var avatar: Media?
    var hasNote: Bool

    init(
        id: Int,
        username: String,
        avatar: Media?,
        hasNote: Bool
    ) {
        self.id = id
        self.username = username
        self.avatar = avatar
        self.hasNote = hasNote
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}
