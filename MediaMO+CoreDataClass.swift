//
//  MediaMO+CoreDataClass.swift
//  tawkGit
//
//  Created by Nazmul Islam on 20/9/21.
//
//

import Foundation
import CoreData

@objc(MediaMO)
public class MediaMO: NSManagedObject {
    func toMedia() -> Media? {
        guard let localName = self.localName,
              let remoteURLStr = self.remoteURL,
              let remoteURL = URL(string: remoteURLStr)
        else {
            return nil
        }

        return Media(remoteURL: remoteURL, localName: localName)
    }
}
