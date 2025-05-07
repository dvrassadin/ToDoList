//
//  CoreDataStack.swift
//  ToDoList
//
//  Created by Daniil Rassadin on 6/5/25.
//

import CoreData
import OSLog

final class CoreDataStack: StorageManager, @unchecked Sendable {
    
    static let shared = CoreDataStack()
    
    // MARK: Properties
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoModel")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load store: \(error)")
            }
        }
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        return container
    }()
    
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "",
        category: "CoreData"
    )
    
    // MARK: Initialization
    
    private init() {}
    
    // MARK: Public Methods
    
    func saveToDos(_ toDos: [ToDo]) {
        persistentContainer.performBackgroundTask { [weak self] backgroundContext in
            toDos.forEach { toDo in
                let coreDataToDo = CoreDataToDo(context: backgroundContext)
                coreDataToDo.id = toDo.id
                coreDataToDo.title = toDo.title
                coreDataToDo.text = toDo.text
                coreDataToDo.created = toDo.created
                coreDataToDo.completed = toDo.completed
            }

            do {
                try backgroundContext.save()
                self?.logger.info("ToDos saved.")
            } catch {
                self?.logger.error("Failed to save To-Do items: \(error.localizedDescription)")
            }
        }
    }
    
    func saveToDo(_ toDo: ToDo) {
        persistentContainer.performBackgroundTask { [weak self] backgroundContext in
            let request = CoreDataToDo.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", toDo.id as CVarArg)
            request.fetchLimit = 1
            
            do {
                let results = try backgroundContext.fetch(request)
                if let existedToDo = results.first {
                    existedToDo.title = toDo.title
                    existedToDo.text = toDo.text
                } else {
                    let coreDataToDo = CoreDataToDo(context: backgroundContext)
                    coreDataToDo.id = toDo.id
                    coreDataToDo.title = toDo.title
                    coreDataToDo.text = toDo.text
                    coreDataToDo.created = toDo.created
                    coreDataToDo.completed = toDo.completed
                }
                try backgroundContext.save()
                self?.logger.info("To Do with ID '\(toDo.id) saved.")
            } catch {
                self?.logger.error("Failed to save To Do: \(error.localizedDescription)")
            }
        }
    }
    
    func updateToDoCompletion(id: UUID, completed: Bool) {
        persistentContainer.performBackgroundTask { [weak self] backgroundContext in
            let request = CoreDataToDo.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            request.fetchLimit = 1
            
            do {
                let results = try backgroundContext.fetch(request)
                
                guard let toDo = results.first else {
                    self?.logger.error("ToDo \(id) not found for update.")
                    return
                }
                
                toDo.completed = completed
                try backgroundContext.save()
                self?.logger.info("ToDo \(id) marked as \(completed ? "completed" : "not completed").")
            } catch {
                self?.logger.error("Failed to update ToDo \(id): \(error.localizedDescription)")
            }
        }
    }
    
    func fetchToDos(completion: @escaping @Sendable ([ToDo]) -> Void) {
        persistentContainer.performBackgroundTask { [weak self] backgroundContext in
            let request = CoreDataToDo.fetchRequest()
            
            do {
                let coreDataToDos = try backgroundContext.fetch(request)
                self?.logger.info("Fetched \(coreDataToDos.count) ToDos from CoreData.")
                let toDos = coreDataToDos.map { coreDataToDo in
                    ToDo(
                        id: coreDataToDo.id ?? UUID(),
                        title: coreDataToDo.title,
                        text: coreDataToDo.text ?? "",
                        created: coreDataToDo.created,
                        completed: coreDataToDo.completed
                    )
                }
                completion(toDos)
            } catch {
                self?.logger.error("Failed to fetch ToDos: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchToDos(matching query: String, completion: @escaping @Sendable ([ToDo]) -> Void) {
        guard !query.isEmpty else {
            fetchToDos { toDos in
                completion(toDos)
            }
            return
        }
        
        persistentContainer.performBackgroundTask { [weak self] backgroundContext in
            let request = CoreDataToDo.fetchRequest()
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@ OR text CONTAINS[cd] %@", query, query)
            request.sortDescriptors = [NSSortDescriptor(keyPath: \CoreDataToDo.created, ascending: true)]
            
            do {
                let coreDataToDos = try backgroundContext.fetch(request)
                let toDos = coreDataToDos.map { cd in
                    ToDo(
                        id: cd.id ?? UUID(),
                        title: cd.title,
                        text: cd.text ?? "",
                        created: cd.created,
                        completed: cd.completed
                    )
                }
                self?.logger.info("Fetched \(coreDataToDos.count) ToDos matching query '\(query)'.")
                completion(toDos)
            } catch {
                self?.logger.error("Failed to fetch ToDos matching query '\(query)': \(error)")
                completion([])
            }
        }
    }
    
    func fetchToDo(withID id: UUID, completion: @escaping @Sendable (ToDo?) -> Void) {
        persistentContainer.performBackgroundTask { [weak self] backgroundContext in
            let request = CoreDataToDo.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            request.fetchLimit = 1
            
            do {
                let results = try backgroundContext.fetch(request)
                guard let coreDataToDo = results.first else {
                    self?.logger.error("No ToDo found with ID '\(id)'.")
                    completion(nil)
                    return
                }
                let toDo = ToDo(
                    id: coreDataToDo.id ?? UUID(),
                    title: coreDataToDo.title,
                    text: coreDataToDo.text ?? "",
                    created: coreDataToDo.created,
                    completed: coreDataToDo.completed
                )
                self?.logger.info("Fetched ToDo with ID '\(id)'.")
                completion(toDo)
            } catch {
                self?.logger.error("Failed to fetch ToDo with ID '\(id)': \(error)")
                completion(nil)
            }
        }
    }
    
    func deleteToDo(withID id: UUID) {
        persistentContainer.performBackgroundTask { [weak self] backgroundContext in
            let fetchRequest = CoreDataToDo.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let toDosToDelete = try backgroundContext.fetch(fetchRequest)
                if !toDosToDelete.isEmpty {
                    toDosToDelete.forEach { backgroundContext.delete($0) }
                    try backgroundContext.save()
                    self?.logger.info("ToDo with ID \(id) deleted.")
                } else {
                    self?.logger.error("No ToDo found with ID \(id) to delete.")
                }
            } catch {
                self?.logger.error("Failed to delete ToDo with ID \(id): \(error.localizedDescription)")
            }
        }
    }
    
}
