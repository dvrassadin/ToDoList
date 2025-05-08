//
//  ToDoListViewMock.swift
//  ToDoListTests
//
//  Created by Daniil Rassadin on 7/5/25.
//

import XCTest
@testable import ToDoList

final class ToDoListViewMock: ToDoListViewProtocol {
    
    // MARK: Spy Variables
    
    private(set) var showLoadingWasCalled = false
    private(set) var hideLoadingWasCalled = false
    
    // MARK: Handlers
    
    var showLoadingHandler: (() -> Void)?
    var displayToDosHandler: (([ToDo]) -> Void)?
    var displayErrorHandler: ((String) -> Void)?
    
    // MARK: Methods
    
    func displayToDos(_ toDos: [ToDoList.ToDo]) {
        displayToDosHandler?(toDos)
    }
    
    func displayError(message: String) {
        displayErrorHandler?(message)
    }
    
    func showLoading() {
        showLoadingWasCalled = true
        showLoadingHandler?()
    }
    
    func hideLoading() {
        hideLoadingWasCalled = true
    }
    
}
