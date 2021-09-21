//
//  UserMO+CoreDataProperties.swift
//  tawkGit
//
//  Created by Nazmul Islam on 21/9/21.
//
//

import Foundation
import CoreData


extension UserMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserMO> {
        return NSFetchRequest<UserMO>(entityName: "UserMO")
    }

    @NSManaged public var avatarURL: String?
    @NSManaged public var note: String?
    @NSManaged public var profileVisited: Bool
    @NSManaged public var userId: Int64
    @NSManaged public var username: String?

}

extension UserMO : Identifiable {

}
