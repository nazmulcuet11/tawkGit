//
//  UserMO+CoreDataProperties.swift
//  tawkGit
//
//  Created by Nazmul Islam on 20/9/21.
//
//

import Foundation
import CoreData


extension UserMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserMO> {
        return NSFetchRequest<UserMO>(entityName: "UserMO")
    }

    @NSManaged public var userId: Int64
    @NSManaged public var username: String?
    @NSManaged public var avatarURL: String?
    @NSManaged public var note: String?
    @NSManaged public var profileVisited: Bool
    @NSManaged public var followers: Int64
    @NSManaged public var following: Int64
    @NSManaged public var name: String?
    @NSManaged public var company: String?
    @NSManaged public var blog: String?
    @NSManaged public var location: String?

}

extension UserMO : Identifiable {

}
