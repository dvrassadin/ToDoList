//
//  ToDoListInteractorMock.swift
//  ToDoListTests
//
//  Created by Daniil Rassadin on 8/5/25.
//

import XCTest
@testable import ToDoList

final class ToDoListInteractorMock: ToDoListInteractorInputProtocol, @unchecked Sendable {
    
    // MARK: Spy Variables
    
    private(set) var fetchToDosWasCalled = false
    private(set) var capturedUUID: UUID?
    private(set) var capturedString: String?
    
    // MARK: Methods
    
    func fetchToDos() {
        fetchToDosWasCalled = true
    }
    
    func searchToDos(with query: String) {
        capturedString = query
    }
    
    func markToDoAsCompleted(withId id: UUID, completed: Bool) {
        capturedUUID = id
    }
    
    func deleteToDo(withId id: UUID) {
        capturedUUID = id
    }
    
}
