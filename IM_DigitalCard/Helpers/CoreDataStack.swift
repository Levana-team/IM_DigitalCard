//
//  CoreDataStack.swift
//  IM_DigitalCard
//
//  Created by elie buff on 29/12/2020.
//

import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.DB_NAME)
        
        container.loadPersistentStores(completionHandler: { (_, error) in
            guard let error = error as NSError? else { return }
            fatalError("Unresolved error: \(error), \(error.userInfo)")
        })
        
        getCoreDataDBPath()
        
        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.undoManager = nil
        container.viewContext.shouldDeleteInaccessibleFaults = true
        
        
        
        return container
    }()
    
    var backgroundContext: NSManagedObjectContext {
        let taskContext = self.persistentContainer.newBackgroundContext()
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        taskContext.undoManager = nil
        
        return taskContext
    }
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    public func save(context: NSManagedObjectContext){
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error: \(error)\nCould not save Core Data context.")
            }
            context.reset() // Reset the context to clean up the cache and low the memory footprint.
        }
    }
    
    public func save() {
        
        if self.viewContext.hasChanges {
            do {
                try self.viewContext.save()
                print("In CoreData.stack.save()")
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    private func getCoreDataDBPath() {
        let path = FileManager
            .default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .last?
            .absoluteString
            .replacingOccurrences(of: "file://", with: "")
            .removingPercentEncoding

        print("Core Data DB Path :: \(path ?? "Not found")")
    }
    
    class func executeBlockAndCommit(_ block: @escaping () -> Void) {
        block()
        CoreDataStack.shared.save()
    }
}



