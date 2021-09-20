//
//  CoreDataStack.swift
//  tawkGit
//
//  Created by Nazmul Islam on 20/9/21.
//

import Foundation
import CoreData

class CoreDataStack {
    private let modelName: String

    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores {
            storeDescription, error in
            if let error = error {
                fatalError("Failed to load core data stores: \(error.localizedDescription)")
            }
            print("Core data stores loaded successfully: \(storeDescription.debugDescription)")
        }
        return container
    }()

    var mainContext: NSManagedObjectContext { container.viewContext }

    init(modelName: String) {
        self.modelName = modelName
    }

    func saveContext() {
        guard mainContext.hasChanges else {
            return
        }

        do {
            try mainContext.save()
        } catch {
            print("Failed to save core data context: \(error.localizedDescription)")
        }
    }
}
