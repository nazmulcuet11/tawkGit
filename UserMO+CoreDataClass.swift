//
//  UserMO+CoreDataClass.swift
//  tawkGit
//
//  Created by Nazmul Islam on 20/9/21.
//
//

import Foundation
import CoreData

@objc(UserMO)
public class UserMO: NSManagedObject {
    func toUser() -> User? {
        guard let username = username else {
            return nil
        }

        return User(
            id: Int(userId),
            username: username,
            avatarURL: avatarURL,
            note: note,
            profileVisited: profileVisited
        )
    }

    func toUserProfile() -> UserProfile? {
        guard let username = username
        else {
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
            location: location,
            note: note
        )
    }
}
