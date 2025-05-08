//
//  ToDoListRouterMock.swift
//  ToDoListTests
//
//  Created by Daniil Rassadin on 7/5/25.
//

import Foundation
@testable import ToDoList

final class ToDoListRouterMock: ToDoListRouterProtocol {
    
    // MARK: Spy Variables
    
    private(set) var navigateToAddToDoWasCalled = false
    
    // MARK: Handlers
    
    var navigateToAddToDoHandler: (() -> Void)?
    var navigateToEditToDoHandler: ((UUID) -> Void)?
    
    // MARK: Methods
    
    func navigateToAddToDo() {
        navigateToAddToDoWasCalled = true
        navigateToAddToDoHandler?()
    }
    
    func navigateToEditToDo(withID id: UUID) {
        navigateToEditToDoHandler?(id)
    }
    
}
