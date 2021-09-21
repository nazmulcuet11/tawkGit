//
//  UserProfile+UserProfileNetworkModel.swift
//  tawkGit
//
//  Created by Nazmul Islam on 20/9/21.
//

import Foundation

extension UserProfile {
    convenience init(from networkModel: UserProfileNetworkModel) {
        self.init(
            id: networkModel.id,
            username: networkModel.login,
            avatarURL: networkModel.avatarURL,
            followers: networkModel.followers,
            following: networkModel.following,
            name: networkModel.name,
            company: networkModel.company,
            blog: networkModel.blog,
            location: networkModel.location
        )
    }

    func transferChanges(from networkModel: UserProfileNetworkModel) {
        id = networkModel.id
        username = networkModel.login
        avatarURL = networkModel.avatarURL
        followers = networkModel.followers
        following = networkModel.following
        name = networkModel.name
        company = networkModel.company
        blog = networkModel.blog
        location = networkModel.location
    }
}
