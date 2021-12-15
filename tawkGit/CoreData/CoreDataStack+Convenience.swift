//
//  CoreDataStack+Convenience.swift
//  tawkGit
//
//  Created by Nazmul Islam on 15/12/21.
//

import Foundation

extension CoreDataStack {
    
    /// Initialize a CoreData stack with SQLite Store
    /// - Parameter modelName: name of the coredata momd file
    convenience init(modelName: String) {
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd") else {
            fatalError("Could not find momd file in the disk")
        }
        
        let storeURL = FileManager.default
            .documentDirectory
            .appendingPathComponent("\(modelName).sqlite")
        
        self.init(
            modelURL: modelURL,
            storeURL: storeURL,
            storeType: .sqlite
        )
    }
}
