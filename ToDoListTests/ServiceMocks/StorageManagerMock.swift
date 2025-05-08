//
//  StorageManagerMock.swift
//  ToDoListTests
//
//  Created by Daniil Rassadin on 7/5/25.
//

import Foundation
@testable import ToDoList

final class StorageManagerMock: StorageManager {
    
    // MARK: Spy Variables
    
    private(set) var fetchAllToDosWasCalled = false
    private(set) var saveToDosWasCalled = false
    private(set) var capturedID: UUID?
    
    // MARK: Handlers
    
    var fetchToDosMatchingHandler: ((String, @escaping ([ToDo]) -> Void) -> Void)?
    
    // MARK: Methods
    
    func saveToDo(_ toDo: ToDoList.ToDo) {
        
    }
    
    func saveToDos(_ toDos: [ToDoList.ToDo]) {
        saveToDosWasCalled = true
    }
    
    func updateToDoCompletion(id: UUID, completed: Bool) {
        capturedID = id
    }
    
    func fetchToDos(completion: @escaping ([ToDoList.ToDo]) -> Void) {
        fetchAllToDosWasCalled = true
        completion([])
    }
    
    func fetchToDos(matching query: String, completion: @escaping ([ToDoList.ToDo]) -> Void) {
        fetchToDosMatchingHandler?(query, completion)
    }
    
    func fetchToDo(withID id: UUID, completion: @escaping (ToDoList.ToDo?) -> Void) {
        
    }
    
    func deleteToDo(withID id: UUID) {
        capturedID = id
    }
    
}
