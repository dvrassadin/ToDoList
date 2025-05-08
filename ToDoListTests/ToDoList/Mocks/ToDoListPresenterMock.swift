//
//  ToDoListPresenterMock.swift
//  ToDoListTests
//
//  Created by Daniil Rassadin on 7/5/25.
//

@testable import ToDoList

final class ToDoListPresenterMock: ToDoListInteractorOutputProtocol, @unchecked Sendable {
    
    // MARK: Spy Variables
    
    private(set) var didFetchToDosWasCalled = false
    
    // MARK: Handlers

    var didFetchToDosHandler: (([ToDoList.ToDo]) -> Void)?
    var didFailToFetchToDosHandler: ((Error) -> Void)?
    
    // MARK: Methods
    
    func didFetchToDos(_ toDos: [ToDoList.ToDo]) {
        didFetchToDosWasCalled = true
        didFetchToDosHandler?(toDos)
    }
    
    func didFailToFetchTodos(error: any Error) {
        didFailToFetchToDosHandler?(error)
    }
    
}
