//
//  CoreDataStack.swift
//  tawkGit
//
//  Created by Nazmul Islam on 20/9/21.
//

import Foundation
import CoreData

enum ContextType {
    case main
    case background
}

class CoreDataStack {
    typealias ExecuationBlock = (NSManagedObjectContext) -> Void

    private let modelName: String
    private let writingQueue: DispatchQueue

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

    private var mainContext: NSManagedObjectContext { container.viewContext }
    private lazy var backgroundContext: NSManagedObjectContext = {
        let context = container.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        return context
    }()

    init(modelName: String, writingQueue: DispatchQueue) {
        self.modelName = modelName
        self.writingQueue = writingQueue
    }

    func saveContext() {
        guard hasChanges() else {
            return
        }

        do {
            try backgroundContext.save()
            try mainContext.save()
        } catch {
            print("Failed to save core data context: \(error.localizedDescription)")
        }
    }

    func perform(on contextType: ContextType, block: @escaping ExecuationBlock) {
        switch contextType {
            case .main:
                mainContext.perform { block(self.mainContext) }
            case .background:
                writingQueue.async {
                    self.backgroundContext.performAndWait {
                        block(self.backgroundContext)
                    }
                }
        }
    }


    func hasChanges() -> Bool {
        return mainContext.hasChanges || backgroundContext.hasChanges
    }
}
