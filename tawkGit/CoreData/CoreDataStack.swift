//
//  CoreDataStack.swift
//  tawkGit
//
//  Created by Nazmul Islam on 20/9/21.
//

import Foundation
import CoreData

final class CoreDataStack {
    
    typealias ExecuationBlock = (NSManagedObjectContext) -> Void
    
    private let modelURL: URL
    private let storeURL: URL
    private let storeType: StoreType
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Could not create model with using file at: \(modelURL.path)")
        }
        return model
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do {
            try coordinator.addPersistentStore(
                ofType: storeType.stringValue,
                configurationName: nil,
                at: storeURL,
                options: [
                    NSMigratePersistentStoresAutomaticallyOption: true,
                    NSInferMappingModelAutomaticallyOption: false
                ]
            )
        } catch {
            fatalError("Failed to add store type: \(storeType.stringValue) at: \(storeURL.path)")
        }
        
        return coordinator
    }()
    
    // used to write data to disk async
    private lazy var parentContext: NSManagedObjectContext = {
        let ctx = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        ctx.persistentStoreCoordinator = persistentStoreCoordinator
        return ctx
    }()

    // used to read data, and as an scratch pad
    // when saved changed pushed to parent context (which is in memory and fast) synchronously
    // parent context then write asynchoronoysly in the background 
    private lazy var childContext: NSManagedObjectContext = {
        let ctx = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        ctx.parent = parentContext
        return ctx
    }()
    
    init(
        modelURL: URL,
        storeURL: URL,
        storeType: StoreType
    ) {
        self.modelURL = modelURL
        self.storeURL = storeURL
        self.storeType = storeType
    }
    
    /// Call this method when you are done with the changes in your managed object model
    /// Changes are not persisted in the db untill you call this method
    func saveContext() {
        guard hasChanges() else {
            return
        }

        // push changes to the parent context synchronously
        childContext.performAndWait {
            do {
                try childContext.save()
            } catch {
                fatalError("Error saving child context: \(error.localizedDescription)")
            }
        }
        
        // write to disk asynchornously
        parentContext.perform {
            do {
                try self.parentContext.save()
            } catch {
                fatalError("Error saving parent context: \(error.localizedDescription)")
            }
        }
    }
    
    /// Perform any kind of database operation through this method
    /// This method make sure the context is accessed from the correct thread and executes the bloc aycnhronously
    /// Make sure your application is compatible asynchoronous database operation
    /// - Parameter block: block of code to execute
    func perform(block: @escaping ExecuationBlock) {
        childContext.perform {
            block(self.childContext)
        }
    }
    
    /// - Returns: true if stack has any changes, no otherwise
    func hasChanges() -> Bool {
        return childContext.hasChanges || parentContext.hasChanges
    }
}

extension CoreDataStack {
    enum StoreType {
        case inMemory, sqlite
        
        var stringValue: String {
            switch self {
            case .sqlite:
                return NSSQLiteStoreType
            case .inMemory:
                return NSInMemoryStoreType
            }
        }
    }
}
