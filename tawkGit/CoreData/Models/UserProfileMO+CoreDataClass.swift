//
//  UserProfileMO+CoreDataClass.swift
//  tawkGit
//
//  Created by Nazmul Islam on 21/9/21.
//
//

import Foundation
import CoreData

@objc(UserProfileMO)
public class UserProfileMO: NSManagedObject {
    func toUserProfile() -> UserProfile? {
        guard let username = username else {
            return nil
        }

        return UserProfile(
            id: Int(userId),
            username: username,
            avatarURL: avatarURL,
            followers: Int(followers),
            following: Int(following),
            name: name,
            company: company,
            blog: blog,
            location: location
        )
    }
}
