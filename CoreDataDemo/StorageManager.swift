//
//  StorageManager.swift
//  CoreDataDemo
//
//  Created by Anton Duplin on 17/8/21.
//

import Foundation
import CoreData

class StorageManager {
    //var taskListData: [Task] = []
    static let shared = StorageManager()
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    
    private var viewContex: NSManagedObjectContext {
         persistentContainer.viewContext
    }
    
    private init() { }

    func fetchData() -> [Task] {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        var taskList: [Task] = []
        do {
            taskList = try viewContex.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
        return taskList
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
  
    
}

