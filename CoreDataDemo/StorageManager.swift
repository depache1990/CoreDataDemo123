//
//  StorageManager.swift
//  CoreDataDemo
//
//  Created by Anton Duplin on 17/8/21.
//

import Foundation
import CoreData

class StorageManager {

    //MARK: Core Data stack
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

    private var viewContex: NSManagedObjectContext
    
    private init() {
      viewContex = persistentContainer.viewContext
    }
    //MARK: Public Methods
    
    func fetchData(completion: (Result<[Task], Error>) -> Void) {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        do {
          let  tasks = try viewContex.fetch(fetchRequest)
            completion(.success(tasks))
        } catch let error {
            completion(.failure(error))
        }
        
        
    }

    //MARK: Save Data
    func save(_ taskName:String, completion: (Task) -> Void) {
       let task = Task(context: viewContex)
                task.name = taskName
                completion(task)
                saveContext()
    }
    
    func edit(_ task: Task, newName: String) {
        task.name = newName
        saveContext()
    }
    
    func delete(_ task: Task) {
        viewContex.delete(task)
        saveContext()
    }
    
    //MARK: - Core Data Saving support
  
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

