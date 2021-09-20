//
//  UserProfile+UserProfileNetworkModel.swift
//  tawkGit
//
//  Created by Nazmul Islam on 20/9/21.
//

import Foundation

extension UserProfileNetworkModel {
    func toUserProfile() -> UserProfile {
        return UserProfile(
            id: id,
            username: login,
            avatarURL: avatarURL,
            followers: followers,
            following: following,
            name: name,
            company: company,
            blog: blog,
            location: location,
            note: nil
        )
    }
}
