//
//  UserProfileMO+CoreDataProperties.swift
//  tawkGit
//
//  Created by Nazmul Islam on 21/9/21.
//
//

import Foundation
import CoreData


extension UserProfileMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserProfileMO> {
        return NSFetchRequest<UserProfileMO>(entityName: "UserProfileMO")
    }

    @NSManaged public var avatarURL: String?
    @NSManaged public var blog: String?
    @NSManaged public var company: String?
    @NSManaged public var followers: Int64
    @NSManaged public var following: Int64
    @NSManaged public var location: String?
    @NSManaged public var name: String?
    @NSManaged public var userId: Int64
    @NSManaged public var username: String?

}

extension UserProfileMO : Identifiable {

}
