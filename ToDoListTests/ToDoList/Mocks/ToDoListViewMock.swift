//
//  ToDoListViewMock.swift
//  ToDoListTests
//
//  Created by Daniil Rassadin on 7/5/25.
//

import XCTest
@testable import ToDoList

final class ToDoListViewMock: ToDoListViewProtocol {
    
    // MARK: Methods
    
    func displayToDos(_ toDos: [ToDoList.ToDo]) {
        
    }
    
    func displayError(message: String) {
        
    }
    
    func showLoading() {
        
    }
    
    func hideLoading() {
        
    }
    
}
