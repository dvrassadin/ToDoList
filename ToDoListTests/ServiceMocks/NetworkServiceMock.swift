//
//  NetworkServiceMock.swift
//  ToDoListTests
//
//  Created by Daniil Rassadin on 7/5/25.
//

import Foundation
@testable import ToDoList

final class NetworkServiceSpy: NetworkService, @unchecked Sendable {
    
    // MARK: Results
    
    var toDosResult: Result<[ToDoList.ToDo], ToDoList.NetworkError>?
    
    // MARK: Spy Variables
    
    private(set) var getToDosWasCalled = false
    
    // MARK: Methods
    
    func getToDos(completion: @escaping @Sendable (Result<[ToDoList.ToDo], ToDoList.NetworkError>) -> Void) {
        getToDosWasCalled = true
        if let toDosResult {
            completion(toDosResult)
        }
    }

}
