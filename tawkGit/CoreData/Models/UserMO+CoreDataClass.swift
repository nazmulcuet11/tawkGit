//
//  UserMO+CoreDataClass.swift
//  tawkGit
//
//  Created by Nazmul Islam on 21/9/21.
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
}
