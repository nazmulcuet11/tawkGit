//
//  MediaMO+CoreDataProperties.swift
//  tawkGit
//
//  Created by Nazmul Islam on 20/9/21.
//
//

import Foundation
import CoreData


extension MediaMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MediaMO> {
        return NSFetchRequest<MediaMO>(entityName: "MediaMO")
    }

    @NSManaged public var localName: String?
    @NSManaged public var remoteURL: String?

}

extension MediaMO : Identifiable {

}
