//
//  UserProfile.swift
//  tawkGit
//
//  Created by Nazmul Islam on 18/9/21.
//

import Foundation

class UserProfile {
    var id: Int
    var username: String
    var avatarURL: String?
    var followers: Int
    var following: Int
    var name: String?
    var company: String?
    var blog: String?
    var location: String?
    var note: String?

    init(
        id: Int,
        username: String,
        avatarURL: String?,
        followers: Int,
        following: Int,
        name: String?,
        company: String?,
        blog: String?,
        location: String?,
        note: String?
    ) {
        self.id = id
        self.username = username
        self.avatarURL = avatarURL
        self.followers = followers
        self.following = following
        self.name = name
        self.company = company
        self.blog = blog
        self.location = location
        self.note = note
    }
}

