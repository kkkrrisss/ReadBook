//
//  CoreDataStack.swift
//  ReadBook
//
//  Created by Кристина Олейник on 24.08.2025.
//

import UIKit
import CoreData


final class CoreDataStack {
    static let shared = CoreDataStack()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                postNotification()
            } catch {
                fatalError("Unresolved error \(error)")
            }
        }
    }
    
    private func postNotification() {
        NotificationCenter.default.post(name: NSNotification.Name("Update"),
                                        object: nil)
    }
}
